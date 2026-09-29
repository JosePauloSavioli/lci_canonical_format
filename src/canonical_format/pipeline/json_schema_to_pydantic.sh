#!/usr/bin/env bash
set -euo pipefail


PIPELINE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$PIPELINE_DIR/.." && pwd)"
SRC_ROOT="$(cd "$PROJECT_ROOT/../.." && pwd)"

SCHEMA_FILE="$PROJECT_ROOT/lca.schema.json"
PYDANTIC_SCHEMA_FILE="$PROJECT_ROOT/lca_pydantic.schema.json"

OUTPUT_ROOT="$PROJECT_ROOT/models"
OUTPUT_FILE="$OUTPUT_ROOT/lca.py"
VALIDATORS_FILE="$OUTPUT_ROOT/pydantic_validators.json"

cd "$PROJECT_ROOT"

python3 "$PIPELINE_DIR/create_pydantic_schema.py" \
    "$SCHEMA_FILE"

mkdir -p "$OUTPUT_ROOT"
rm -f "$OUTPUT_FILE"
touch "$OUTPUT_ROOT/__init__.py"

datamodel-codegen \
    --input "$PYDANTIC_SCHEMA_FILE" \
    --input-file-type jsonschema \
    --output-model-type pydantic_v2.BaseModel \
    --class-name LCADataSet \
    --output "$OUTPUT_FILE" \
    --target-python-version 3.12 \
    --extra-fields forbid \
    --use-standard-collections \
    --field-constraints \
    --disable-timestamp \
    --formatters builtin \
    --reuse-model \
    --use-generic-base-class \
    --use-type-alias \
    --strict-types str bool \
    --validators "$VALIDATORS_FILE"

python3 "$PIPELINE_DIR/convert_to_decimal.py" "$OUTPUT_FILE"

PYTHONPATH="$SRC_ROOT" python3 - "$OUTPUT_FILE" <<'PY'
import importlib
import sys


path = sys.argv[1]
module = importlib.import_module("Lavoisier.conversions.models.lca")

incomplete_models = [
    name
    for name, model in vars(module).items()
    if (
        isinstance(model, type)
        and model.__module__ == module.__name__
        and issubclass(model, module.BaseModel)
        and not getattr(model, "__pydantic_complete__", True)
    )
]

if incomplete_models:
    with open(path, "a", encoding="utf-8") as file:
        file.write("\n\n")
        for name in incomplete_models:
            file.write(f"{name}.model_rebuild()\n")

print(f"Rebuild calls added: {len(incomplete_models)}")
for name in incomplete_models:
    print(f"  {name}")
PY

PYTHONPATH="$SRC_ROOT" python3 - "$OUTPUT_FILE" <<'PY'
import importlib
import sys
from types import UnionType
from typing import Annotated, Literal, Union, get_args, get_origin

path = sys.argv[1]
module = importlib.import_module("Lavoisier.conversions.models.lca")


def members(value):
    if hasattr(value, "__value__") and not isinstance(value, type):
        return members(value.__value__)

    origin = get_origin(value)

    if origin is Annotated:
        return members(get_args(value)[0])

    if origin in (UnionType, Union):
        result = []
        for item in get_args(value):
            result.extend(members(item))
        return tuple(dict.fromkeys(result))

    if isinstance(value, type) and issubclass(value, module.BaseModel):
        return (value,)

    return ()


def literal(model, field):
    annotation = model.model_fields[field].annotation

    if hasattr(annotation, "__value__") and not isinstance(annotation, type):
        annotation = annotation.__value__

    values = get_args(annotation)
    if get_origin(annotation) is not Literal or len(values) != 1:
        raise TypeError(f"{model.__name__}.{field} is not a single Literal")

    return values[0]


def tuple_expression(values):
    names = [value.__name__ for value in values]
    return ", ".join(names) + ("," if len(names) == 1 else "")


def union_expression(values):
    return " | ".join(value.__name__ for value in values)


external_models = members(module.ExternalUncertaintyField)
external_fields = tuple(
    next(iter(model.model_fields))
    for model in external_models
    if len(model.model_fields) == 1
)

quantities = tuple(dict.fromkeys(
    members(module.NonLazyQuantity)
    + members(module.NonLazyQuantitySet)
))

tables = members(module.Table)

datasets = {}
for model in members(module.LCADataSet):
    datasets.setdefault(literal(model, "datasetType"), []).append(model)

formulas = members(module.Formula)
references = members(module.SimpleInputFromEntry)

parameters = members(module.Parameter)
inputs = tuple(
    model
    for model in parameters
    if model not in formulas and model not in references
)

discriminated = {}
for model in (
    value
    for value in vars(module).values()
    if (
        isinstance(value, type)
        and value.__module__ == module.__name__
        and issubclass(value, module.BaseModel)
    )
):
    for field in ("quantityType", "categoryType"):
        if field in model.model_fields:
            try:
                value = literal(model, field)
            except TypeError:
                continue
            discriminated[field, value] = model

lazy_results = []
for field in ("quantityType", "categoryType"):
    for (candidate_field, value), lazy in discriminated.items():
        if candidate_field != field or not value.startswith("lazy"):
            continue
        result_value = f"resulting{value[4:]}"
        result = discriminated.get((field, result_value))
        if result is not None:
            lazy_results.append((lazy, result, field, result_value))

parameterized_entries = tuple(
    model
    for lazy, result, _, _ in lazy_results
    for model in (lazy, result)
)

lines = [
    "",
    "",
    f"EXTERNAL_FIELDS = {{{', '.join(repr(field) for field in external_fields)}}}",
    f"QUANTITIES = {tuple_expression(quantities)}",
    f"TABLES = {tuple_expression(tables)}",
    "",
    "DATASET_MODELS = {",
    *(
        f"    {dataset_type!r}: {union_expression(models)},"
        for dataset_type, models in datasets.items()
    ),
    "}",
    f"FORMULAS = {tuple_expression(formulas)}",
    f"INPUTS = {tuple_expression(inputs)}",
    f"REFERENCES = {tuple_expression(references)}",
    "PARAMETERS = FORMULAS + INPUTS + REFERENCES",
    f"PARAMETERIZED_ENTRIES = {tuple_expression(parameterized_entries)}",
    "LAZY_RESULTS = {",
    *(
        f"    {lazy.__name__}: ({result.__name__}, {field!r}, {value!r}),"
        for lazy, result, field, value in lazy_results
    ),
    "}",
    "",
]

with open(path, "a", encoding="utf-8") as file:
    file.write("\n".join(lines))

print("Generated model registries:")
print(f"  EXTERNAL_FIELDS: {len(external_fields)}")
print(f"  QUANTITIES: {len(quantities)}")
print(f"  TABLES: {len(tables)}")
print(f"  DATASET_MODELS: {len(datasets)}")
print(f"  FORMULAS: {len(formulas)}")
print(f"  INPUTS: {len(inputs)}")
print(f"  REFERENCES: {len(references)}")
print(f"  PARAMETERIZED_ENTRIES: {len(parameterized_entries)}")
print(f"  LAZY_RESULTS: {len(lazy_results)}")
PY

echo "Pydantic models generated: $OUTPUT_FILE"

touch "$PIPELINE_DIR/__init__.py"

PYTHONPATH="$SRC_ROOT" \
python3 -m Lavoisier.conversions.pipeline.validate_pydantic_examples

