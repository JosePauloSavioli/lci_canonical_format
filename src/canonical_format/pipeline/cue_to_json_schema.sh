#!/usr/bin/env bash
set -euo pipefail


PIPELINE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$PIPELINE_DIR/.." && pwd)"

RAW_SCHEMA="$PROJECT_ROOT/lca_raw.schema.json"
SCHEMA="$PROJECT_ROOT/lca.schema.json"
EXAMPLES_ROOT="$PROJECT_ROOT/examples"


cd "$PROJECT_ROOT"

cue def -f -t jsonschema \
    --out jsonschema \
    -e '#AnyDataSet' \
    -o "$RAW_SCHEMA" \
    ./cue_schemas:lca_model

echo 'Created raw JSON Schema.'

python3 "$PIPELINE_DIR/clean_json_schema.py" \
    "$RAW_SCHEMA"

datasets=(
    "embrapa_1_model:model"
    "embrapa_1_process:process"
    "embrapa_1_production_system:productionSystem"
    "embrapa_1_project:project"
    "embrapa_1_registry:registry"
)
files=()

for entry in "${datasets[@]}"; do
    filename="${entry%%:*}"
    expression="${entry#*:}"
    output="$EXAMPLES_ROOT/${filename}.json"

    cue export -f "$EXAMPLES_ROOT/${filename}.cue" \
        -e "$expression" \
        --out json \
        --outfile "$output"

    files+=("$output")
done

echo 'Created example JSON files.'

python3 "$PIPELINE_DIR/validate_json_schema_and_examples.py" \
    "$SCHEMA" \
    "${files[@]}"

