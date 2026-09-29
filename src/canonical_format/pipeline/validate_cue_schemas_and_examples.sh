#!/usr/bin/env bash
set -euo pipefail


PIPELINE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$PIPELINE_DIR/.." && pwd)"


cd "$PROJECT_ROOT"

runtime_packages=(
    actors_and_sources
    bibo_dc
    categories
    flows
    parameterization
    processes
    production_systems
    project
    properties
    provenance
    quantities
    references
    registry
    rights
    standard_categories
    standard_properties
    standard_uncertainties
    uncertainty
    units
    utils
    vcard
)

for package in "${runtime_packages[@]}"; do
    echo "Package:$package"
    cue vet -c "./cue_schemas:$package"
done


echo "Package:standard_properties:JSONSchema"
cue vet -c -t jsonschema "./cue_schemas:standard_properties"

echo "Package:standard_categories:JSONSchema"
cue vet -c -t jsonschema "./cue_schemas:standard_categories"

echo "Package:lca_model:JSONSchema"
cue vet -c -t jsonschema "./cue_schemas:lca_model"


example_packages=(
    process
    model
    production_system
    main_project
    registry_example
)

for package in "${example_packages[@]}"; do
    echo "Examples:$package"
    cue vet -c "./examples:$package"
done

