#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug  5 15:30:00 2026

@author: jotape42p
"""

from decimal import Decimal, InvalidOperation
from numbers import Real

import numpy as np
import openturns as ot
from uncertainties import std_dev, ufloat


def decimal(value):
    if isinstance(value, bool):
        raise TypeError("Boolean values are not numbers")

    if isinstance(value, Decimal):
        result = value
    elif isinstance(value, Real):
        result = Decimal(str(value))
    elif isinstance(value, str):
        try:
            result = Decimal(value.strip())
        except InvalidOperation as error:
            raise ValueError(f"Invalid decimal value: {value!r}") from error
    else:
        raise TypeError(f"Expected a real number, Decimal or numeric string, received: {type(value).__name__}")

    if not result.is_finite():
        raise ValueError(f"Non-finite decimal value: {value!r}")

    return result


class Quantity:

    def __init__(self, magnitude, unit):
        self._quantity = decimal(magnitude) * unit

    @classmethod
    def _from_pint(cls, quantity):
        value = cls.__new__(cls)
        value._quantity = quantity
        return value

    @property
    def magnitude(self):
        return self._quantity.magnitude

    @property
    def units(self):
        return self._quantity.units

    @property
    def dimensionality(self):
        return self._quantity.dimensionality

    def to(self, unit):
        return type(self)._from_pint(self._quantity.to(unit))

    def conversion_to(self, unit):
        zero = (Decimal("0") * self.units).to(unit).magnitude
        one = (Decimal("1") * self.units).to(unit).magnitude
        return one - zero, zero

    @staticmethod
    def _number(value):
        if isinstance(value, (bool, str)):
            raise TypeError("Expected a real number, Decimal or Quantity, received: {type(value).__name__}")
        return decimal(value)

    def _coerce(self, value):
        if isinstance(value, Quantity):
            return value._quantity
        return self._number(value)

    def _operation(self, other, operation, reverse=False):
        if not isinstance(other, (Quantity, Real, Decimal)) or isinstance(other, bool):
            return NotImplemented

        left = self._coerce(other) if reverse else self._quantity
        right = self._quantity if reverse else self._coerce(other)
        return type(self)._from_pint(operation(left, right))

    def __add__(self, other):
        return self._operation(other, lambda left, right: left + right)

    def __radd__(self, other):
        return self._operation(other, lambda left, right: left + right, True)

    def __sub__(self, other):
        return self._operation(other, lambda left, right: left - right)

    def __rsub__(self, other):
        return self._operation(other, lambda left, right: left - right, True)

    def __mul__(self, other):
        return self._operation(other, lambda left, right: left * right)

    def __rmul__(self, other):
        return self._operation(other, lambda left, right: left * right, True)

    def __truediv__(self, other):
        return self._operation(other, lambda left, right: left / right)

    def __rtruediv__(self, other):
        return self._operation(other, lambda left, right: left / right, True)

    def __pow__(self, other):
        if isinstance(other, Quantity):
            raise TypeError("Quantity exponents are not supported")
        return self._operation(other, lambda left, right: left ** right)

    def __rpow__(self, other):
        exponent = self._quantity.to("1").magnitude
        result = self._number(other) ** exponent
        return type(self)._from_pint(result * (self._quantity ** 0))

    def __neg__(self):
        return type(self)._from_pint(-self._quantity)

    def __pos__(self):
        return type(self)._from_pint(+self._quantity)

    def _comparison(self, other, operation):
        if not isinstance(other, (Quantity, Real, Decimal)) or isinstance(other, bool):
            return NotImplemented
        return operation(self._quantity, self._coerce(other))

    def __lt__(self, other):
        return self._comparison(other, lambda left, right: left < right)

    def __le__(self, other):
        return self._comparison(other, lambda left, right: left <= right)

    def __gt__(self, other):
        return self._comparison(other, lambda left, right: left > right)

    def __ge__(self, other):
        return self._comparison(other, lambda left, right: left >= right)

    def __eq__(self, other):
        try:
            return self._comparison(other, lambda left, right: left == right)
        except (TypeError, ValueError):
            return False

    def __ne__(self, other):
        result = self.__eq__(other)
        return NotImplemented if result is NotImplemented else not result


class ArrayQuantity:

    def __init__(self, values, unit, kind, context, variance=None):
        self.values = np.asanyarray(values)
        self.units = unit
        self.kind = kind
        self.context = context
        self.variance = None if variance is None else np.asanyarray(variance)

    @property
    def dimensionality(self):
        return self.units.dimensionality

    def to(self, unit):
        zero = (Decimal("0") * self.units).to(unit).magnitude
        one = (Decimal("1") * self.units).to(unit).magnitude
        factor = float(one - zero)
        values = self.values * factor + float(zero)
        variance = None if self.variance is None else self.variance * factor ** 2
        return type(self)(values, unit, self.kind, self.context, variance)

    def _match(self, other):
        if self.kind != other.kind:
            raise TypeError("Raster and time-series quantities cannot be combined")
        if self.context["alignment"] != other.context["alignment"]:
            raise ValueError(f"{self.kind.capitalize()} quantities are not aligned")

    def _scalar(self, value):
        if isinstance(value, QuantityWithDistribution):
            value = value.as_variance()
        if isinstance(value, QuantityWithVariance):
            return value.nominal, float(value.variance)
        if isinstance(value, Quantity):
            return value, None
        return Quantity(value, self.units ** 0), None

    def _operation(self, other, operation, name, reverse=False):
        same = other is self
        if not isinstance(other, (ArrayQuantity, Quantity, Real, Decimal)) or isinstance(other, bool):
            return NotImplemented
        if isinstance(other, ArrayQuantity):
            self._match(other)
            if name in {"add", "subtract"}:
                other = other.to(self.units)
            values = other.values
            variance = other.variance
            other_unit = other.units
        else:
            other, variance = self._scalar(other)
            if name in {"add", "subtract"}:
                factor = float(other.conversion_to(self.units)[0])
                other = other.to(self.units)
                variance = None if variance is None else variance * factor ** 2
            values = float(other.magnitude)
            other_unit = other.units

        left = values if reverse else self.values
        right = self.values if reverse else values
        left_variance = variance if reverse else self.variance
        right_variance = self.variance if reverse else variance
        result = operation(left, right)

        if name in {"add", "subtract"}:
            unit = self.units
        elif name == "multiply":
            unit = self.units * other_unit
        else:
            unit = other_unit / self.units if reverse else self.units / other_unit

        if self.variance is None and variance is None:
            result_variance = None
        elif same:
            result_variance = {
                "add": 4 * self.variance,
                "subtract": None,
                "multiply": 4 * self.values ** 2 * self.variance,
                "divide": None,
            }[name]
        else:
            left_variance = 0 if left_variance is None else left_variance
            right_variance = 0 if right_variance is None else right_variance
            result_variance = {
                "add": left_variance + right_variance,
                "subtract": left_variance + right_variance,
                "multiply": right ** 2 * left_variance + left ** 2 * right_variance,
                "divide": left_variance / right ** 2 + left ** 2 * right_variance / right ** 4,
            }[name]

        return type(self)(result, unit, self.kind, self.context, result_variance)

    def __add__(self, other):
        return self._operation(other, lambda left, right: left + right, "add")

    def __radd__(self, other):
        return self._operation(other, lambda left, right: left + right, "add", True)

    def __sub__(self, other):
        return self._operation(other, lambda left, right: left - right, "subtract")

    def __rsub__(self, other):
        return self._operation(other, lambda left, right: left - right, "subtract", True)

    def __mul__(self, other):
        return self._operation(other, lambda left, right: left * right, "multiply")

    def __rmul__(self, other):
        return self._operation(other, lambda left, right: left * right, "multiply", True)

    def __truediv__(self, other):
        return self._operation(other, lambda left, right: left / right, "divide")

    def __rtruediv__(self, other):
        return self._operation(other, lambda left, right: left / right, "divide", True)

    def __pow__(self, other):
        if isinstance(other, ArrayQuantity):
            raise TypeError("Array exponents are not supported")
        other, variance = self._scalar(other)
        if variance is not None:
            raise NotImplementedError("Uncertain exponents are not supported")
        exponent = other.to(self.units ** 0).magnitude
        values = self.values ** float(exponent)
        variance = None if self.variance is None or exponent == 0 else (
            float(exponent) * self.values ** (float(exponent) - 1)
        ) ** 2 * self.variance
        return type(self)(values, self.units ** exponent, self.kind, self.context, variance)

    def __rpow__(self, other):
        other, variance = self._scalar(other)
        if variance is not None:
            raise NotImplementedError("Uncertain bases are not supported")
        values = self.to(self.units ** 0).values
        base = float(other.to(self.units ** 0).magnitude)
        result = base ** values
        variance = None if self.variance is None else (result * np.log(base)) ** 2 * self.variance
        return type(self)(result, self.units ** 0, self.kind, self.context, variance)

    def __neg__(self):
        return type(self)(-self.values, self.units, self.kind, self.context, self.variance)

    def __pos__(self):
        return self

    def _comparison(self, other):
        raise NotImplementedError("Array comparisons are not implemented")

    __lt__ = __le__ = __gt__ = __ge__ = __eq__ = __ne__ = _comparison


class QuantityWithUncertainty(Quantity):

    def __init__(self, magnitude, unit, uncertainty):
        super().__init__(magnitude, unit)
        self.uncertainty = uncertainty

    @classmethod
    def _from_parts(cls, quantity, uncertainty):
        value = cls.__new__(cls)
        value._quantity = quantity._quantity
        value.uncertainty = uncertainty
        return value

    @property
    def nominal(self):
        return Quantity._from_pint(self._quantity)

    def to(self, unit):
        return type(self)._from_parts(self.nominal.to(unit), self._uncertainty_to(unit))

    def __add__(self, other):
        return self._operation(other, lambda left, right: left + right, "add")

    def __radd__(self, other):
        return self._operation(other, lambda left, right: left + right, "add", True)

    def __sub__(self, other):
        return self._operation(other, lambda left, right: left - right, "subtract")

    def __rsub__(self, other):
        return self._operation(other, lambda left, right: left - right, "subtract", True)

    def __mul__(self, other):
        return self._operation(other, lambda left, right: left * right, "multiply")

    def __rmul__(self, other):
        return self._operation(other, lambda left, right: left * right, "multiply", True)

    def __truediv__(self, other):
        return self._operation(other, lambda left, right: left / right, "divide")

    def __rtruediv__(self, other):
        return self._operation(other, lambda left, right: left / right, "divide", True)


class QuantityWithVariance(QuantityWithUncertainty):

    @property
    def variance(self):
        return decimal(std_dev(self.uncertainty)) ** 2

    def _uncertainty_to(self, unit):
        factor, offset = self.conversion_to(unit)
        return self.uncertainty * float(factor) + float(offset)

    @staticmethod
    def _value(value, unit=None):
        if isinstance(value, QuantityWithDistribution):
            value = value.as_variance()
        if isinstance(value, QuantityWithVariance):
            return value.uncertainty if unit is None else value._uncertainty_to(unit)
        if isinstance(value, Quantity):
            quantity = value._quantity if unit is None else value._quantity.to(unit)
            return float(quantity.magnitude)
        return float(Quantity._number(value))

    @classmethod
    def _result(cls, quantity, uncertainty):
        if std_dev(uncertainty) == 0:
            return quantity
        return cls._from_parts(quantity, uncertainty)

    def _operation(self, other, operation, name, reverse=False):
        if isinstance(other, ArrayQuantity):
            return NotImplemented
        if isinstance(other, QuantityWithDistribution):
            other = other.as_variance()
        elif not isinstance(other, Quantity):
            other = self._number(other)

        left = other if reverse else self
        right = self if reverse else other
        left_nominal = left.nominal if isinstance(left, QuantityWithUncertainty) else left
        right_nominal = right.nominal if isinstance(right, QuantityWithUncertainty) else right
        result = operation(left_nominal, right_nominal)
        unit = result.units if name in {"add", "subtract"} else None
        uncertainty = operation(self._value(left, unit), self._value(right, unit))
        return type(self)._result(result, uncertainty)

    def __pow__(self, other):
        if isinstance(other, QuantityWithUncertainty):
            raise NotImplementedError("Uncertain exponents are not supported")
    
        exponent = other._quantity.to("1").magnitude if isinstance(other, Quantity) else self._number(other)
        result = self.nominal ** exponent
        uncertainty = self.uncertainty ** float(exponent)
        return type(self)._result(result, uncertainty)
    
    def __rpow__(self, other):
        if isinstance(other, QuantityWithUncertainty):
            raise NotImplementedError("Two uncertain power operands are not supported")
    
        self._quantity.to("1")
        base = other._quantity.to("1").magnitude if isinstance(other, Quantity) else self._number(other)
        result = base ** self.magnitude
        quantity = Quantity._from_pint(result * (self._quantity ** 0))
        uncertainty = float(base) ** self.uncertainty
        return type(self)._result(quantity, uncertainty)

    def __neg__(self):
        return type(self)._from_parts(-self.nominal, -self.uncertainty)

    def __pos__(self):
        return self


class QuantityWithDistribution(QuantityWithUncertainty):

    def _uncertainty_to(self, unit):
        factor, offset = self.conversion_to(unit)
        distribution = float(factor) * self.uncertainty
        return distribution if offset == 0 else distribution + float(offset)

    def as_variance(self):
        stdev = self.uncertainty.getStandardDeviation()[0]
        return QuantityWithVariance._from_parts(
            self.nominal,
            ufloat(float(self.magnitude), float(stdev)),
        )

    def samples(self, size):
        sample = self.uncertainty.getSample(size)
        return [
            Quantity(decimal(sample[index, 0]), self.units)
            for index in range(size)
        ]

    @staticmethod
    def _value(value, unit=None):
        if isinstance(value, QuantityWithDistribution):
            return value.uncertainty if unit is None else value._uncertainty_to(unit)
        if isinstance(value, Quantity):
            quantity = value._quantity if unit is None else value._quantity.to(unit)
            return float(quantity.magnitude)
        return float(Quantity._number(value))

    @staticmethod
    def _deterministic_zero(value):
        if isinstance(value, QuantityWithUncertainty):
            return False
        if isinstance(value, Quantity):
            return value.magnitude == 0
        return Quantity._number(value) == 0

    def _operation(self, other, operation, name, reverse=False):
        if isinstance(other, ArrayQuantity):
            return NotImplemented
        if isinstance(other, QuantityWithVariance):
            return self.as_variance()._operation(other, operation, name, reverse)
        if not isinstance(other, Quantity):
            other = self._number(other)

        left = other if reverse else self
        right = self if reverse else other
        left_nominal = left.nominal if isinstance(left, QuantityWithDistribution) else left
        right_nominal = right.nominal if isinstance(right, QuantityWithDistribution) else right
        result = operation(left_nominal, right_nominal)

        if left is right and name in {"subtract", "divide"}:
            return result
        if name == "multiply" and (
            self._deterministic_zero(left)
            or self._deterministic_zero(right)
        ):
            return result

        if left is right:
            uncertainty = {
                "add": lambda value: 2.0 * value,
                "multiply": lambda value: value.sqr(),
            }[name](left.uncertainty)
        else:
            unit = result.units if name in {"add", "subtract"} else None
            left_value = self._value(left, unit)
            right_value = self._value(right, unit)
            right_uncertain = isinstance(right, QuantityWithDistribution)
            operations = {
                "add": lambda a, b: a + b,
                "subtract": lambda a, b: a + (-1.0 * b),
                "multiply": lambda a, b: a * b,
                "divide": lambda a, b: a * b.inverse() if right_uncertain else a * (1.0 / b),
            }

            try:
                uncertainty = operations[name](left_value, right_value)
            except Exception as error:
                raise NotImplementedError(f"OpenTURNS cannot evaluate uncertain {name}") from error

        return type(self)._from_parts(result, uncertainty)

    def __pow__(self, other):
        if isinstance(other, QuantityWithUncertainty):
            raise NotImplementedError("Uncertain exponents are not supported")
    
        exponent = other._quantity.to("1").magnitude if isinstance(other, Quantity) else self._number(other)
        result = self.nominal ** exponent
        if exponent == 0:
            return result
    
        direct = {
            Decimal("1"): lambda value: value,
            Decimal("2"): lambda value: value.sqr(),
            Decimal("0.5"): lambda value: value.sqrt(),
            Decimal("-1"): lambda value: value.inverse(),
        }
    
        try:
            uncertainty = (
                direct[exponent](self.uncertainty) if exponent in direct else ot.CompositeDistribution(
                    ot.SymbolicFunction(["x"], [f"x^{float(exponent)}"]), self.uncertainty
                )
            )
        except Exception as error:
            raise NotImplementedError("OpenTURNS cannot evaluate the uncertain power") from error
    
        return type(self)._from_parts(result, uncertainty)
    
    def __rpow__(self, other):
        if isinstance(other, QuantityWithUncertainty):
            raise NotImplementedError("Two uncertain power operands are not supported")
    
        self._quantity.to("1")
        base = other._quantity.to("1").magnitude if isinstance(other, Quantity) else self._number(other)
        result = base ** self.magnitude
        quantity = Quantity._from_pint(result * (self._quantity ** 0))
    
        try:
            uncertainty = ot.CompositeDistribution(
                ot.SymbolicFunction(["x"], [f"{float(base)}^x"]),
                self.uncertainty,
            )
        except Exception as error:
            raise NotImplementedError("OpenTURNS cannot evaluate the uncertain exponent") from error
    
        return type(self)._from_parts(quantity, uncertainty)

    def __neg__(self):
        return type(self)._from_parts(-self.nominal, -1.0 * self.uncertainty)

    def __pos__(self):
        return self
