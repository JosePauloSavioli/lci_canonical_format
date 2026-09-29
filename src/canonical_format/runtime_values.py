#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug  6 22:10:00 2026

@author: jotape42p
"""

import csv
import json
import operator
from datetime import datetime
from decimal import Decimal
from numbers import Real

import numpy as np
from fiona.transform import transform_geom
from rasterio.features import geometry_mask
from rasterio.mask import mask
from rasterio.windows import Window, transform as window_transform

from .ANTLR.ast_builder import AstBuilder
from .ANTLR.ast_evaluator import AstEvaluator
from .calculation_quantities import ArrayQuantity, Quantity, decimal
from .models.lca import (
    CSVTable,
    EXTERNAL_FIELDS,
    CategoryFormula,
    JSONTable,
    QuantitativeChoice,
    RegionalizedQuantitySet,
    SingleCategory,
    SingleQuantity,
    TimeSeriesQuantitySet,
    Variance,
)


def _invalid_constant(value):
    raise ValueError(f"Invalid JSON numeric constant: {value}")


def _external(value, expected=None, reader=None, label="Uncertainty"):
    if value is None:
        return None
    if hasattr(value, "model_dump"):
        value = value.model_dump(mode="python", by_alias=True, exclude_none=True)
    if isinstance(value, list):
        return [_external(item, expected, reader, label) for item in value]
    if not isinstance(value, dict):
        return value
    if len(value) == 1:
        field, external = next(iter(value.items()))
        if field in EXTERNAL_FIELDS:
            if field != expected:
                raise ValueError(f"{label} cannot use {field!r}")
            return external if reader is None else reader(external)
    return {
        key: _external(item, expected, reader, label)
        for key, item in value.items()
    }


def _external_values(uncertainty, field, label):
    values = []
    _external(uncertainty, field, lambda value: values.append(value) or value, label)
    return values


def _scalar(runtime, source, value, field=None, reader=None):
    return runtime.quantities.scalar(
        decimal(value), source.unit, _external(source.uncertainty, field, reader),
    )


def _array(value, kind):
    if not isinstance(value, ArrayQuantity) or value.kind != kind:
        raise TypeError(f"{kind} operations require a {kind} quantity")
    return value


def _runtime_quantity(runtime, value, *operands): # Maintains formulas in the runtime quantity layer
    if isinstance(value, _RuntimeQuantityMath):
        return value

    if isinstance(value, ArrayQuantity):
        try:
            runtime_type = {
                "raster": RuntimeRasterQuantity,
                "time-series": RuntimeTimeSeriesQuantity,
            }[value.kind]
        except KeyError as error:
            raise TypeError(f"Unsupported array quantity kind: {value.kind!r}") from error

    elif isinstance(value, Quantity):
        runtime_type = RuntimeScalarQuantity

    elif isinstance(value, (Real, Decimal)) and not isinstance(value, bool):
        runtime_type = RuntimeScalarQuantity
        value = runtime.quantities.number(value)

    else:
        return value

    source = next(
        (
            operand.source
            for operand in operands
            if isinstance(operand, runtime_type) and operand.source is not None
        ),
        None,
    )
    return runtime_type.from_value(runtime, value, source)


def _binary_operation(operation, reverse=False):
    def calculate(self, other):
        operand = other.value if isinstance(other, _RuntimeQuantityMath) else other
        left, right = (operand, self.value) if reverse else (self.value, operand)
        return _runtime_quantity(self.runtime, operation(left, right), self, other)
    return calculate


def _unary_operation(operation):
    def calculate(self):
        result = operation(self.value)
        return self if result is self.value else _runtime_quantity(self.runtime, result, self)
    return calculate


class _RuntimeQuantityMath:

    @classmethod
    def from_value(cls, runtime, value, source=None):
        runtime_value = cls.__new__(cls)
        runtime_value.runtime = runtime
        runtime_value.source = source
        runtime_value.loaded = True
        runtime_value._value = value
        return runtime_value

    @property
    def value(self):
        if not self.loaded:
            self._value = self._read()
            self.loaded = True
        return self._value

    def to(self, unit_id):
        return _runtime_quantity(
            self.runtime, self.runtime.quantities.convert(self.value, unit_id), self,
        )

    __add__ = _binary_operation(operator.add)
    __radd__ = _binary_operation(operator.add, True)
    __sub__ = _binary_operation(operator.sub)
    __rsub__ = _binary_operation(operator.sub, True)
    __mul__ = _binary_operation(operator.mul)
    __rmul__ = _binary_operation(operator.mul, True)
    __truediv__ = _binary_operation(operator.truediv)
    __rtruediv__ = _binary_operation(operator.truediv, True)
    __pow__ = _binary_operation(operator.pow)
    __rpow__ = _binary_operation(operator.pow, True)
    __lt__ = _binary_operation(operator.lt)
    __le__ = _binary_operation(operator.le)
    __gt__ = _binary_operation(operator.gt)
    __ge__ = _binary_operation(operator.ge)
    __eq__ = _binary_operation(operator.eq)
    __ne__ = _binary_operation(operator.ne)
    __neg__ = _unary_operation(operator.neg)
    __pos__ = _unary_operation(operator.pos)


class RuntimeScalarQuantity(_RuntimeQuantityMath):

    def __init__(self, runtime, source):
        self.runtime = runtime
        self.source = source
        runtime.quantities.unit(source.unit) # Eager Validation
        self.loaded = True
        self._value = _scalar(runtime, source, source.amount)

    def result(self, unit_id, *args):
        return self.runtime.quantities.to_entry(self.value, unit_id)


class _RuntimeArrayQuantity(_RuntimeQuantityMath):

    def __init__(self, runtime, source):
        self.runtime = runtime
        self.source = source
        runtime.quantities.unit(source.unit)  # Eager Validation
        self.loaded = False
        self._value = None

    def _selection(self, *args):
        if not self.loaded:
            return self._read(*args)
        if all(arg is None for arg in args):
            return self.value
        return self._slice(self.value, *args)

    def slice(self, *args):
        return _runtime_quantity(self.runtime, self._selection(*args), self)


class RuntimeRasterQuantity(_RuntimeArrayQuantity):

    kind = "raster"

    def __init__(self, runtime, source):
        super().__init__(runtime, source)

        with runtime.files.open_raster(source.file) as raster:
            bands = {source.rasterBand} | set(
                _external_values(source.uncertainty, "rasterBand", "Regionalized quantity uncertainty")
            )
            invalid = [band for band in bands if band < 0 or band >= raster.count]
            if invalid:
                raise IndexError(f"Raster bands do not exist in {source.file!r}: {invalid!r}")

    def _geometries(self, geometry_file, target_crs, feature_index=None):
        shapes = []
        with self.runtime.files.open_vector(geometry_file) as source:
            source_crs = source.crs_wkt or source.crs
            for index, feature in enumerate(source):
                if feature_index is not None and index != feature_index:
                    continue
                geometry = feature["geometry"]
                if geometry is None:
                    continue
                if source_crs and target_crs:
                    geometry = transform_geom(source_crs, target_crs.to_wkt(), geometry)
                shapes.append(geometry)
        if not shapes:
            raise ValueError("The geometry file contains no geometries")
        return shapes

    @staticmethod
    def _raster_band(raster, band, shapes=None):
        if shapes is None:
            return raster.read(band + 1, masked=True), raster.transform
        return mask(raster, shapes, crop=True, filled=False, indexes=band + 1)

    @staticmethod
    def _raster_context(profile):
        return {
            "alignment": (profile.get("crs"), profile["transform"], profile["width"], profile["height"]),
            "profile": profile,
        }

    def _read(self, geometry_file=None, feature_index=None):
        with self.runtime.files.open_raster(self.source.file) as raster:
            shapes = (
                None
                if geometry_file is None
                else self._geometries(geometry_file, raster.crs, feature_index)
            )
            values, transform = self._raster_band(raster, self.source.rasterBand, shapes)
            uncertainty = _external(
                self.source.uncertainty,
                "rasterBand",
                lambda band: self._raster_band(raster, band, shapes)[0],
            )
            profile = raster.profile.copy()
            profile.update(
                height=values.shape[0], width=values.shape[1], transform=transform,
            )

        return self.runtime.quantities.array(
            values, self.source.unit, self.kind, self._raster_context(profile), uncertainty
        )

    def _slice(self, value, geometry_file, feature_index=None):
        value = _array(value, self.kind)
        profile = value.context["profile"].copy()
        outside = geometry_mask(
            self._geometries(geometry_file, profile.get("crs"), feature_index),
            out_shape=value.values.shape,
            transform=profile["transform"],
        )
        combined = np.ma.getmaskarray(value.values) | outside
        rows, columns = np.where(~combined)
        if rows.size == 0:
            raise ValueError("The geometry does not contain raster values")

        row_start, row_stop = rows.min(), rows.max() + 1
        column_start, column_stop = columns.min(), columns.max() + 1
        selection = np.s_[row_start:row_stop, column_start:column_stop]
        values = np.ma.array(
            np.ma.getdata(value.values)[selection], mask=combined[selection],
        )
        variance = None if value.variance is None else np.ma.array(
            np.ma.getdata(value.variance)[selection], mask=combined[selection],
        )
        window = Window(
            column_start, row_start, column_stop - column_start, row_stop - row_start
        )
        profile.update(
            height=values.shape[0],
            width=values.shape[1],
            transform=window_transform(window, profile["transform"]),
        )
        return ArrayQuantity(
            values, value.units, value.kind, self._raster_context(profile), variance
        )

    def zonal(self, geometry_file, statistic="mean", feature_index=None):
        value = _array(self._selection(geometry_file, feature_index), self.kind)
        operations = {
            "mean": np.mean,
            "sum": np.sum,
            "min": np.min,
            "max": np.max,
            "median": np.median,
            "count": lambda values: values.size,
        }
        if statistic not in operations:
            raise ValueError(f"Unsupported raster statistic: {statistic!r}")
        if value.variance is not None and statistic in {"min", "max", "median"}:
            raise NotImplementedError(f"Uncertain raster {statistic} is not implemented")

        values = np.ma.asarray(value.values).compressed()
        if values.size == 0:
            raise ValueError("The geometry does not contain raster values")
        result = decimal(operations[statistic](values))
        if statistic == "count":
            return _runtime_quantity(self.runtime, self.runtime.quantities.number(result), self)

        uncertainty = None
        if value.variance is not None:
            variance = np.ma.asarray(value.variance).compressed()
            uncertainty = {
                "uncertaintyType": "variance",
                "variance": (
                    decimal(np.sum(variance)) / Decimal(values.size) ** 2
                    if statistic == "mean"
                    else decimal(np.sum(variance))
                ),
            }
        return _runtime_quantity(
            self.runtime, self.runtime.quantities.quantity(result, value.units, uncertainty), self
        )

    def result(self, unit_id, name):
        value = _array(self.value, self.kind)
        target = self.runtime.files.target(name, ".tif")
        profile = value.context["profile"].copy()
        dtype = np.result_type(
            value.values.dtype,
            value.variance.dtype if value.variance is not None else value.values.dtype,
        )
        profile.update(count=2 if value.variance is not None else 1, dtype=dtype)

        with self.runtime.files.open_raster(target, "w", **profile) as destination:
            destination.write(
                value.values.astype(dtype), 1, masked=np.ma.isMaskedArray(value.values)
            )
            if value.variance is not None:
                destination.write(
                    value.variance.astype(dtype), 2, masked=np.ma.isMaskedArray(value.variance)
                )

        return RegionalizedQuantitySet(
            file=self.runtime.files.relative(target),
            quantityType="regionalizedQuantitySet",
            rasterBand=0,
            unit=unit_id,
            uncertainty=None if value.variance is None else Variance(
                uncertaintyType="variance",
                variance={"rasterBand": 1},
            ),
        )


class _CSVRuntimeQuantity: 
    
    def _csv_fields(self, index_field, label):
        required = {getattr(self.source, index_field), self.source.dataColumnName}
        with self.runtime.files.open_csv(self.source.file) as file:
            fields = csv.DictReader(file).fieldnames
        if fields is None:
            raise ValueError(f"{label} has no header: {self.source.file!r}")
        required |= set(_external_values(self.source.uncertainty, "dataColumnName", label))
        missing = required - set(fields)
        if missing:
            raise KeyError(f"{label} columns are missing from {self.source.file!r}: {sorted(missing)!r}")


class RuntimeTimeSeriesQuantity(_CSVRuntimeQuantity, _RuntimeArrayQuantity):

    kind = "time-series"

    def __init__(self, runtime, source):
        super().__init__(runtime, source)
        self._csv_fields("timeColumnName", "Time-series")

    def _datetime(self, value):
        text = str(value).strip()
        if text.endswith("Z"):
            text = text[:-1] + "+00:00"
        return datetime.fromisoformat(text)

    def _bounds(self, start, end):
        return (
            self._datetime(start) if start is not None else None,
            self._datetime(end) if end is not None else None,
        )

    def _selected(self, timestamp, start, end):
        return (start is None or timestamp >= start) and (end is None or timestamp <= end)

    @staticmethod
    def _period(timestamp, step):
        try:
            return {
                "hour": timestamp.strftime("%Y-%m-%dT%H"),
                "day": timestamp.strftime("%Y-%m-%d"),
                "month": timestamp.strftime("%Y-%m"),
                "year": timestamp.strftime("%Y"),
            }[step]
        except KeyError as error:
            raise ValueError(f"Unsupported time step: {step!r}") from error

    def _rows(self, start=None, end=None, step=None, period=None):
        start, end = self._bounds(start, end)
        rows = []
        with self.runtime.files.open_csv(self.source.file) as file:
            for row in csv.DictReader(file):
                timestamp = self._datetime(row[self.source.timeColumnName])
                if (
                    self._selected(timestamp, start, end)
                    and (step is None or self._period(timestamp, step) == period)
                ):
                    rows.append((timestamp, row))
        if not rows:
            raise ValueError("The selected time-series interval is empty")
        return rows

    def _read(self, start=None, end=None, step=None, period=None):
        rows = self._rows(start, end, step, period)
        values = np.array([float(decimal(row[self.source.dataColumnName])) for _, row in rows])
        uncertainty = _external(
            self.source.uncertainty,
            "dataColumnName",
            lambda column: np.array([float(decimal(row[column])) for _, row in rows]),
        )
        return self.runtime.quantities.array(
            values,
            self.source.unit,
            self.kind,
            {
                "alignment": tuple(timestamp for timestamp, _ in rows),
                "timestamps": [row[self.source.timeColumnName] for _, row in rows],
            },
            uncertainty,
        )

    def _slice(self, value, start=None, end=None, step=None, period=None):
        value = _array(value, self.kind)
        start, end = self._bounds(start, end)
        selected = np.array([
            self._selected(timestamp, start, end)
            and (step is None or self._period(timestamp, step) == period)
            for timestamp in value.context["alignment"]
        ])
        if not np.any(selected):
            raise ValueError("The selected time-series interval is empty")
        return ArrayQuantity(
            value.values[selected],
            value.units,
            value.kind,
            {
                "alignment": tuple(
                    timestamp for timestamp, keep in zip(value.context["alignment"], selected) if keep
                ),
                "timestamps": [
                    timestamp for timestamp, keep in zip(value.context["timestamps"], selected) if keep
                ],
            },
            None if value.variance is None else value.variance[selected],
        )

    def periods(self, step, start=None, end=None):
        value = _array(self._selection(start, end), self.kind)
        return tuple(dict.fromkeys(
            self._period(timestamp, step) for timestamp in value.context["alignment"]
        ))

    def _mean(self, value):
        value = _array(value, "time-series")
        values = np.ma.asarray(value.values).compressed()
        uncertainty = None
        if value.variance is not None:
            variance = np.ma.asarray(value.variance).compressed()
            uncertainty = {
                "uncertaintyType": "variance",
                "variance": decimal(np.sum(variance)) / Decimal(values.size) ** 2,
            }
        return self.runtime.quantities.quantity(
            decimal(np.mean(values)), value.units, uncertainty,
        )

    def mean(self, start=None, end=None):
        return _runtime_quantity(self.runtime, self._mean(self._selection(start, end)), self)

    def mean_period(self, step, period, start=None, end=None):
        return _runtime_quantity(
            self.runtime,
            self._mean(self._selection(start, end, step, period)),
            self,
        )

    def result(self, unit_id, name):
        value = _array(self.value, self.kind)
        target = self.runtime.files.target(name, ".csv")

        with self.runtime.files.open_csv(target, "w") as file:
            writer = csv.writer(file)
            writer.writerow(
                ["time", name]
                + ([] if value.variance is None else [f"{name}_variance"])
            )
            writer.writerows(
                zip(value.context["timestamps"], value.values)
                if value.variance is None
                else zip(value.context["timestamps"], value.values, value.variance)
            )

        return TimeSeriesQuantitySet(
            dataColumnName=name,
            file=self.runtime.files.relative(target),
            quantityType="timeSeriesQuantitySet",
            timeColumnName="time",
            unit=unit_id,
            uncertainty=None if value.variance is None else Variance(
                uncertaintyType="variance",
                variance={"dataColumnName": f"{name}_variance"},
            ),
        )


class RuntimeCSVTable:

    def __init__(self, runtime, source):
        self.runtime = runtime
        self.source = source
        with self.runtime.files.open_csv(source.file) as file:
            fields = csv.DictReader(file).fieldnames
        if fields is None:
            raise ValueError(f"CSV table has no header: {source.file!r}")
        if source.keyColumnName not in fields:
            raise KeyError(
                f"CSV table key column is missing from {source.file!r}: "
                f"{source.keyColumnName!r}"
            )
        self.loaded = False
        self._data = None

    @property
    def data(self):
        if not self.loaded:
            with self.runtime.files.open_csv(self.source.file) as file:
                rows = list(csv.DictReader(file))
            self._data = {str(row[self.source.keyColumnName]): row for row in rows}
            if len(self._data) != len(rows):
                raise ValueError("Repeated CSV table key")
            self.loaded = True
        return self._data

    def get(self, key, data_path=None):
        key = str(key)
        if key not in self.data:
            raise ValueError(f"CSV row not found: {key!r}")
        row = self.data[key]
        if data_path is None:
            return row
        if data_path not in row:
            raise KeyError(f"CSV table column not found: {data_path!r}")
        text = row[data_path].strip()
        try:
            return decimal(text)
        except (TypeError, ValueError):
            return text


class RuntimeJSONTable:

    def __init__(self, runtime, source):
        self.runtime = runtime
        self.source = source
        runtime.files.file(source.file)
        self.loaded = False
        self._data = None

    def _read_json(self):
        with self.runtime.files.open_json(self.source.file) as file:
            return json.load(file, parse_float=Decimal, parse_constant=_invalid_constant)

    @property
    def data(self):
        if not self.loaded:
            self._data = self._read_json()
            self.loaded = True
        return self._data

    def _json_pointer(self, pointer):
        value = self.data
        for part in pointer.lstrip("/").split("/") if pointer else ():
            part = part.replace("~1", "/").replace("~0", "~")
            value = value[int(part)] if isinstance(value, list) else value[part]
        return value

    def get(self, key, data_path=None):
        key = str(key)
        value = self._json_pointer(data_path)
        if key not in value:
            raise ValueError(f"JSON key not found: {key!r}")
        return value[key]


def runtime_choice(runtime, source, table, key):
    value = table.get(key, source.dataPath)
    if not isinstance(source, QuantitativeChoice):
        if isinstance(value, dict):
            value = SingleCategory.model_validate(
                {"categoryType": "singleCategory", **value}
            ).label
        else:
            value = SingleCategory(
                categoryType="singleCategory", label=value,
            ).label
        return value

    reader = lambda path: table.get(key, path)
    return RuntimeScalarQuantity.from_value(
        runtime,
        _scalar(runtime, source, value, "dataPath", reader),
    )


def _runtime_functions(runtime):
    return {
        "quantity": runtime.quantities.from_ucum,
        "time.mean": RuntimeTimeSeriesQuantity.mean,
        "time.slice": RuntimeTimeSeriesQuantity.slice,
        "raster.zonal": RuntimeRasterQuantity.zonal,
        "raster.slice": RuntimeRasterQuantity.slice,
    } | runtime.functions


class RuntimeFormula:

    def __init__(self, source, runtime, variables):
        parsed = AstBuilder.parse(source.formula)
        self.runtime = runtime
        self.source = source
        self.ast = parsed["ast"]
        self.variables = {name: variables[name] for name in parsed["variables"]}
        self.dependencies = frozenset(self.variables.values())
        self.functions = {
            name: lambda *args, _function=function: _runtime_quantity(
                runtime, _function(*args), *args
            )
            for name, function in _runtime_functions(runtime).items()
        }

    def name(self):
        return (
            self.source.variableName
            if self.source.variableName is not None
            else f"formula_{self.source.id}"
        )

    def evaluate(self, resolve):
        return AstEvaluator(
            {name: resolve(key) for name, key in self.variables.items()},
            self.functions,
        ).evaluate(self.ast)

    def solve(self, resolve):
        value = self.evaluate(resolve)
        if isinstance(self.source, CategoryFormula):
            if getattr(value, "categoryType", None) == "singleCategory":
                return value.label, value.model_copy(deep=True)
            return value, SingleCategory(categoryType="singleCategory", label=value)
        value = _runtime_quantity(self.runtime, value)
        if not isinstance(value, _RuntimeQuantityMath):
            raise TypeError(f"Quantity formula returned: {type(value).__name__}")
        value = value.to(self.source.expectedUnit)
        return value, value.result(self.source.expectedUnit, self.name())



RUNTIME_VALUES = {
    SingleQuantity: RuntimeScalarQuantity,
    RegionalizedQuantitySet: RuntimeRasterQuantity,
    TimeSeriesQuantitySet: RuntimeTimeSeriesQuantity,
    CSVTable: RuntimeCSVTable,
    JSONTable: RuntimeJSONTable,
}


def runtime_value(runtime, source):
    try:
        runtime_type = RUNTIME_VALUES[type(source)]
    except KeyError as error:
        raise TypeError(f"Unsupported runtime value: {type(source).__name__}") from error
    return runtime_type(runtime, source)

