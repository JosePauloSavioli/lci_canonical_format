#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug  5 14:20:00 2026

@author: jotape42p
"""

import re
from decimal import Decimal

from ucumvert import PintUcumRegistry


TOLERANCE = Decimal("1e-9")
UCUM = PintUcumRegistry(non_int_type=Decimal)


def _field(value, name):
    if isinstance(value, dict):
        return value.get(name)
    return getattr(value, name, None)


def _plain(value):
    if hasattr(value, "root"):
        return _plain(value.root)
    if hasattr(value, "model_dump"):
        return value.model_dump(by_alias=True, exclude_none=True)
    if isinstance(value, dict):
        return {key: _plain(item) for key, item in value.items()}
    if isinstance(value, list):
        return [_plain(item) for item in value]
    if hasattr(value, "value"):
        return value.value
    return value


def _key(value):
    value = _plain(value)
    if isinstance(value, dict):
        return "dict", tuple((key, _key(item)) for key, item in sorted(value.items()))
    if isinstance(value, list):
        return "list", tuple(_key(item) for item in value)
    if isinstance(value, Decimal):
        return "Decimal", str(value)
    return type(value).__name__, value


def _unique(values, field, label):
    seen = set()

    for value in values or []:
        item = value if field is None else _field(value, field)
        if item is None:
            continue
        item = _key(item)
        if item in seen:
            raise ValueError(f"Repeated {label}: {item}")
        seen.add(item)


def _number(value):
    if isinstance(value, bool):
        return None
    if isinstance(value, (int, Decimal)):
        return value
    return None


def _close(first, second, relative=True):
    first = Decimal(str(first))
    second = Decimal(str(second))
    tolerance = TOLERANCE
    if relative:
        tolerance = max(tolerance, TOLERANCE * max(abs(first), abs(second)))
    return abs(first - second) <= tolerance


def _ordered(lower, upper, label, strict=False):
    lower = _number(lower)
    upper = _number(upper)
    if lower is None or upper is None:
        return
    invalid = lower >= upper if strict else lower > upper
    if invalid:
        operator = "less than" if strict else "less than or equal to"
        raise ValueError(f"{label} minimum must be {operator} its maximum")


def _validate_coordinate(value, lower, upper, label):
    amount = _number(_field(value, "amount"))
    if amount is not None and not lower <= amount <= upper:
        raise ValueError(f"{label} must be between {lower} and {upper}")
    return value


def _reference_key(reference):
    data = _plain(reference)
    target_type = data.get("targetType")
    identifier = {
        "parameter": data.get("parameterId"),
        "exchange": data.get("exchangeId"),
        "property": data.get("propertyId"),
    }.get(target_type)

    return data.get("fileId"), target_type, identifier


def _validate_currency_units(value, currency_units):
    if isinstance(value, (list, tuple)):
        for item in value:
            _validate_currency_units(item, currency_units)
        return

    if isinstance(value, dict):
        fields = value
    elif hasattr(value, "model_fields"):
        fields = {name: getattr(value, name) for name in type(value).model_fields}
    else:
        return

    if "property" in fields:
        return
    if fields.get("unit") in currency_units:
        raise ValueError("Currency units can only be used by properties")

    for item in fields.values():
        if item is not None:
            _validate_currency_units(item, currency_units)


def _flow_dimensionality(unit):
    try:
        dimensions = UCUM.from_ucum(_field(unit, "shortName")).units.dimensionality
    except Exception as error:
        raise ValueError(f"Invalid UCUM flow unit: {_field(unit, 'shortName')!r}") from error

    invalid = {
        str(dimension): exponent
        for dimension, exponent in dimensions.items()
        if str(dimension) != "[time]" and exponent < 0
    }
    if invalid:
        raise ValueError(
            f"Flow unit dimensionality can only have negative exponents for time: {invalid}"
        )
    return tuple(sorted((str(dimension), exponent) for dimension, exponent in dimensions.items()))


def _collect_variables(node):
    variables = set()
    def walk(value):
        if isinstance(value, dict):
            if value.get("type") == "variable":
                variables.add(value["name"])

            for item in value.values():
                walk(item)
        elif isinstance(value, list):
            for item in value:
                walk(item)
    walk(node)
    return variables


def _parse_formula(source):
    from antlr4 import CommonTokenStream, InputStream
    from antlr4.error.ErrorListener import ErrorListener

    from ..ANTLR.ast_builder import AstBuilder
    from ..ANTLR.python.CalculationExpressionLexer import CalculationExpressionLexer
    from ..ANTLR.python.CalculationExpressionParser import CalculationExpressionParser

    class FormulaErrorListener(ErrorListener):
        def __init__(self):
            self.errors = []
        def syntaxError(self, recognizer, symbol, line, column, message, error):
            self.errors.append(f"line {line}:{column} {message}")

    listener = FormulaErrorListener()
    lexer = CalculationExpressionLexer(InputStream(source))
    lexer.removeErrorListeners()
    lexer.addErrorListener(listener)

    tokens = CommonTokenStream(lexer)
    parser = CalculationExpressionParser(tokens)
    parser.removeErrorListeners()
    parser.addErrorListener(listener)
    tree = parser.expression()

    if listener.errors:
        raise ValueError("Invalid formula: " + "; ".join(listener.errors))
    return AstBuilder().visit(tree)


def _check_cycles(graph):
    visiting = set()
    visited = set()

    def visit(node, path):
        if node in visiting:
            start = path.index(node)
            cycle = path[start:] + [node]
            raise ValueError("Circular formula dependency: " + " -> ".join(str(item) for item in cycle))
        if node in visited:
            return

        visiting.add(node)
        path.append(node)

        for dependency in graph.get(node, set()):
            visit(dependency, path)

        path.pop()
        visiting.remove(node)
        visited.add(node)

    for node in graph:
        visit(node, [])


def reject_orcid(value, info):
    if value == "orcid":
        raise ValueError("'orcid' is reserved for ORCIDActorIdentification")
    return value


def reject_source_system(value, info):
    if value in {"doi", "issn"}:
        raise ValueError(f"{value!r} is reserved for a specific source identification")
    return value


def reject_standard(value, info):
    if value == "standard":
        raise ValueError("'standard' is reserved for the standard activity type")
    return value


def reject_ilcd(value, info):
    if value == "ILCD":
        raise ValueError("'ILCD' is reserved for the ILCD review type")
    return value


def _validate_registry_prefix(values, expected, index):
    if values is None or len(values) <= index:
        raise ValueError(f"Category at position {index + 1} must be {expected}")
    if type(values[index]).__name__ != expected:
        raise ValueError(f"Category at position {index + 1} must be {expected}")
    return values


def validate_bcp47_registry_prefix(values, info):
    return _validate_registry_prefix(values, "BCP47ReferenceSystem", 0)


def validate_ucum_registry_prefix(values, info):
    return _validate_registry_prefix(values, "UCUMReferenceSystem", 1)


def validate_start_not_after_end(value, info):
    end = info.data.get("end")

    if end is not None and value > end:
        raise ValueError("Start must not be after end")

    return value


def validate_latitude(value, info):
    return _validate_coordinate(value, -90, 90, "Latitude")


def validate_longitude(value, info):
    return _validate_coordinate(value, -180, 180, "Longitude")


def validate_last_edit(value, info):
    creation = info.data.get("creation")

    if creation is not None and value < creation:
        raise ValueError("Last edit must not be before creation")

    return value


def validate_minimum_not_above_maximum(value, info):
    _ordered(value, info.data.get("maximum"), "Interval")
    return value


def validate_minimum_below_maximum(value, info):
    _ordered(value, info.data.get("maximum"), "Distribution", strict=True)
    return value


def validate_triangular_parameters(value, info):
    lower = info.data.get("lowerLimit")
    shape = info.data.get("shape")
    upper = value

    _ordered(lower, upper, "Triangular distribution", strict=True)

    lower_number = _number(lower)
    shape_number = _number(shape)
    upper_number = _number(upper)

    if lower_number is not None and shape_number is not None:
        if shape_number < lower_number:
            raise ValueError("Triangular shape must not be below the lower limit")

    if shape_number is not None and upper_number is not None:
        if shape_number > upper_number:
            raise ValueError("Triangular shape must not be above the upper limit")

    return value


def validate_hypergeometric_parameters(value, info):
    population = _number(value)
    successes = _number(info.data.get("numberOfSuccesses"))
    trials = _number(info.data.get("numberOfTrials"))

    if population is None:
        return value

    if successes is not None and successes > population:
        raise ValueError("Number of successes must not exceed population size")

    if trials is not None and trials > population:
        raise ValueError("Number of trials must not exceed population size")

    return value


def validate_mixture_weights(value, info):
    total = sum(_field(distribution, "weight") for distribution in value)

    if not _close(total, 1, relative=False):
        raise ValueError(f"Mixture distribution weights must sum to 1, received {total}")

    return value


def validate_covariance_row(value, info):
    _unique(value, "id", "covariance column reference")
    return value


def validate_covariance_matrix(value, info):
    _unique(value, "id", "covariance row reference")
    rows = {}

    for row in value:
        row_key = _key(_field(row, "id"))
        rows[row_key] = {
            _key(_field(item, "id")): _field(item, "value")
            for item in _field(row, "values")
        }

    for row_key, columns in rows.items():
        diagonal = columns.get(row_key)
        if diagonal is not None and diagonal < 0:
            raise ValueError("Covariance diagonal values must be non-negative")

        for column_key, covariance in columns.items():
            reverse = rows.get(column_key, {}).get(row_key)
            if reverse is None:
                continue
            if not _close(covariance, reverse):
                raise ValueError("Covariance matrix must be symmetric")

    return value


def validate_linking_values(value, info):
    _unique(value, "id", "provider reference")
    total = sum(_field(item, "value") for item in value)

    if total > Decimal("1") + TOLERANCE:
        raise ValueError(f"Provider shares must not exceed 1, received {total}")

    return value


def validate_linking_rows(value, info):
    _unique(value, "id", "consumer reference")
    return value


def validate_process_exchange_reference(value, info):
    exchange = (
        info.data.get("inputExchangeId")
        or info.data.get("outputExchangeId")
    )

    if exchange is None:
        return value

    process_file = _field(value, "fileId")
    exchange_file = _field(exchange, "fileId")
    if process_file != exchange_file:
        raise ValueError("Process and exchange references must point to the same file")
    return value


def validate_functional_quantity(value, info):
    if value <= 0:
        raise ValueError("Functional reference quantity must be greater than zero")
    return value


def validate_model_parameters(value, info):
    variables = {}
    parameter_ids = {}

    for parameter in value:
        parameter_id = _field(parameter, "id")
        variable_name = _field(parameter, "variableName")
        parameter_ids[parameter_id] = parameter

        if variable_name is None:
            continue
        if re.compile(r"^[A-Za-z_][A-Za-z_0-9]*$").fullmatch(variable_name) is None:
            raise ValueError(f"Invalid parameter variable name: {variable_name!r}")
        if variable_name in variables:
            raise ValueError(f"Repeated parameter variable name: {variable_name!r}")
        variables[variable_name] = parameter

    graph = {parameter_id: set() for parameter_id in parameter_ids}

    for parameter_id, parameter in parameter_ids.items():
        if _field(parameter, "parameterType") != "formula":
            continue

        ast = _parse_formula(_field(parameter, "formula"))
        formula_variables = _collect_variables(ast)
        missing = sorted(formula_variables - variables.keys())

        if missing:
            raise ValueError("Unknown formula variable(s): " + ", ".join(repr(name) for name in missing))
        graph[parameter_id] = {_field(variables[name], "id") for name in formula_variables}

    _check_cycles(graph)
    return value


def validate_parameterization_models(value, info):
    _unique(value, "id", "model id")

    parameter_ids = []
    for model in value:
        parameter_ids.extend(_field(parameter, "id") for parameter in _field(model, "parameters"))

    _unique(parameter_ids, None, "parameter id")
    return value


def validate_scenario_values(value, info):
    seen = set()

    for entry in value:
        reference = _field(entry, "entryId")
        key = _reference_key(reference)
        if key in seen:
            raise ValueError(f"Repeated scenario value target: {key}")
        seen.add(key)

    return value


# Backward-compatible function name for older post-processing code.
# The generated model must bind this logic to Scenario.values, not Scenario.changes.
def validate_scenario_changes(value, info):
    return validate_scenario_values(value, info)


def validate_unique_actors(value, info):
    _unique(value, "id", "actor id")
    return value


def validate_unique_categories(value, info):
    identifiers = [
        _field(category, "id") or _field(category, "fileId")
        for category in value or []
    ]
    _unique(identifiers, None, "category registry id")
    return value


def validate_unique_exchanges(value, info):
    _unique(value, "id", "exchange id")
    return value


def validate_unique_flowables(value, info):
    _unique(value, "id", "flowable id")
    return value


# Backward-compatible alias for older generated models.
def validate_unique_flows(value, info):
    return validate_unique_flowables(value, info)


def validate_unique_properties(value, info):
    _unique(value, "id", "property registry id")
    return value


def validate_unique_sources(value, info):
    _unique(value, "id", "source id")
    return value


def validate_unique_units(value, info):
    _unique(value, "id", "unit id")
    return value


def validate_unique_tables(value, info):
    _unique(value, "id", "table id")
    return value


def validate_unique_activities(value, info):
    _unique(value, "id", "activity id")
    return value


def validate_unique_production_systems(value, info):
    _unique(value, "fileId", "production system reference")
    return value


def validate_unique_transformations(value, info):
    seen = set()

    for transformation in value:
        key = (
            _key(_field(transformation, "reference")),
            _field(transformation, "name"),
        )

        if key in seen:
            raise ValueError(f"Repeated transformation: {key}")
        seen.add(key)

    return value


def validate_process_registry(value, info):
    # ProcessDataSet.registry is now a RegistryFileReference. Cross-file
    # flowable/unit validation cannot be performed by a field validator on
    # that reference alone; it belongs in bundle/solver validation.
    return value


def validate_production_system_process_instances(value, info):
    instance_references = [_field(instance, "id") for instance in value or []]
    _unique(instance_references, None, "process instance")

    process_ids = {
        _field(reference, "fileId")
        for reference in instance_references
        if reference is not None
    }

    linking = info.data.get("linking")
    if linking is None:
        return value

    shares = {}
    foreground = _field(linking, "foregroundPartialLinkingMatrix")
    backgrounds = _field(linking, "backgroundPartialLinkingMatrices") or []

    if foreground is not None:
        for row in _field(foreground, "linking") or []:
            row_reference = _field(row, "id")
            row_process = _field(_field(row_reference, "processId"), "fileId")

            if row_process not in process_ids:
                raise ValueError(
                    f"Foreground linking points to an unknown process instance: {row_process}"
                )

            row_key = _key(row_reference)
            shares[row_key] = shares.get(row_key, Decimal("0")) + sum(
                _field(item, "value")
                for item in _field(row, "values") or []
            )

            for item in _field(row, "values") or []:
                provider = _field(item, "id")
                provider_process = _field(_field(provider, "processId"), "fileId")

                if provider_process not in process_ids:
                    raise ValueError(
                        f"Foreground linking points to an unknown provider process instance: "
                        f"{provider_process}"
                    )

    for background in backgrounds:
        for row in _field(background, "linking") or []:
            row_reference = _field(row, "id")
            row_process = _field(_field(row_reference, "processId"), "fileId")

            if row_process not in process_ids:
                raise ValueError(
                    f"Background linking points to an unknown process instance: {row_process}"
                )

            row_key = _key(row_reference)
            shares[row_key] = shares.get(row_key, Decimal("0")) + sum(
                _field(item, "value")
                for item in _field(row, "values") or []
            )

    for reference, total in shares.items():
        if total > Decimal("1") + TOLERANCE:
            raise ValueError(
                f"Combined provider shares must not exceed 1 for {reference}, "
                f"received {total}"
            )

    return value


# Backward-compatible function name. The generated model must bind this
# validator to ProductionSystemDataSet.processInstances, not .processes.
def validate_production_system_processes(value, info):
    return validate_production_system_process_instances(value, info)


