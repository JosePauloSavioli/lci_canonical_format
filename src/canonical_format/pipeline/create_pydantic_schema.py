#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug  4 07:41:43 2026

@author: jotape42p
"""

import json
import sys


### Helpers 


# Build a reference path
def ref_path(name):
    return f"#/$defs/{name}"


# Build a reference schema
def ref(name):
    return {"$ref": ref_path(name)}


# Build a closed object schema
def object_schema(properties, required=None):
    if required is None:
        required = list(properties)

    return {
        "type": "object",
        "properties": properties,
        "required": required,
        "additionalProperties": False,
    }


# Find nested constant values (discorver the discriminator values)
def find_const(node, defs, visited=None):
    if visited is None:
        visited = set()
    if not isinstance(node, dict):
        return None
    if "const" in node:
        return node["const"]

    reference = node.get("$ref")
    if isinstance(reference, str) and reference.startswith("#/$defs/") and reference not in visited:
        return find_const(defs[reference.removeprefix("#/$defs/")], defs, visited | {reference})
    for keyword in ("allOf", "oneOf", "anyOf"):
        for alternative in node.get(keyword, []):
            result = find_const(alternative, defs, visited.copy())
            if result is not None:
                return result
    return None


# Replace one reference with another in a recursive way
def replace_ref(node, old_ref, new_ref):
    if isinstance(node, dict):
        if node.get("$ref") == old_ref:
            node["$ref"] = new_ref
        for value in node.values():
            replace_ref(value, old_ref, new_ref)
    elif isinstance(node, list):
        for value in node:
            replace_ref(value, old_ref, new_ref)


# Renames a $defs entry and updates all references pointing to it (better naming in Pydantic classes)
def rename_definition(schema, definitions, old_name, new_name):
    if old_name not in definitions:
        return
    
    definitions[new_name] = definitions.pop(old_name)
    replace_ref(schema, ref_path(old_name), ref_path(new_name))


# Move an inline property schema to a named definition in $defs with a useful name (creates a $ref as well)
def name_property_schema(definitions, owner_name, property_name, schema_name):
    properties = definitions[owner_name]["properties"]
    definitions[schema_name] = properties[property_name]
    properties[property_name] = ref(schema_name)

    return definitions[schema_name]


# Merge object schemas into a single object
def merge_object_schemas(*schemas):
    properties = {}
    required = []

    for schema in schemas:
        properties.update(schema.get("properties", {}))
        required.extend(schema.get("required", []))

    return object_schema(properties, list(dict.fromkeys(required)))


### Discriminator handling


# Add a discriminator to facilitate pydantic generation (apply to standard properties)
def add_discriminator(union_schema, field_name, definitions):
    alternatives = union_schema.get("oneOf") or union_schema.get("anyOf") or []
    mapping = {}
    for alternative in alternatives:
        reference = alternative["$ref"]
        model_schema = definitions[reference.removeprefix("#/$defs/")]
        field_schema = model_schema["properties"][field_name]
        value = find_const(field_schema, definitions)
        if value is None:
            raise ValueError(f"No constant {field_name!r} found for {reference}")
        if value in mapping:
            raise ValueError(f"Duplicate discriminator value: {value}")
        mapping[value] = reference

    union_schema["discriminator"] = {"propertyName": field_name, "mapping": mapping}


# Prepare the standard property registry
def prepare_standard_registry(definitions):
    any_registry = definitions["AnyPropertyRegistry"]
    alternatives = any_registry["anyOf"]
    standard_registry = definitions.get("StandardPropertyRegistry")

    if standard_registry is None:
        nested_registry = next(
            (alternative for alternative in alternatives if "anyOf" in alternative),
            None,
        )

        if nested_registry is None:
            standard_alternatives = [
                alternative
                for alternative in alternatives
                if alternative.get("$ref") != ref_path("ExtensionPropertyRegistry")
            ]
        else:
            standard_alternatives = nested_registry["anyOf"]

        extension_registry = next(
            alternative
            for alternative in alternatives
            if alternative.get("$ref") == ref_path("ExtensionPropertyRegistry")
        )

        standard_registry = {"anyOf": standard_alternatives}
        definitions["StandardPropertyRegistry"] = standard_registry
        any_registry["anyOf"] = [
            ref("StandardPropertyRegistry"),
            extension_registry,
        ]

    add_discriminator(standard_registry, "id", definitions)


### Compatibility corrections


# Avoid complicated generation by changing extension-ID exclusion chains to UUID
def extension_ids_to_uuid(node):
    extension_refs = {
        ref_path("ExtensionCategoryId"),
        ref_path("ExtensionPropertyId"),
    }

    if isinstance(node, dict):
        alternatives = node.get("allOf")

        if isinstance(alternatives, list) and any(
            isinstance(alternative, dict)
            and alternative.get("$ref") in extension_refs
            for alternative in alternatives
        ):
            node.clear()
            node.update(ref("UUID"))
            return

        if node.get("$ref") in extension_refs:
            node["$ref"] = ref_path("UUID")

        for value in node.values():
            extension_ids_to_uuid(value)
    elif isinstance(node, list):
        for value in node:
            extension_ids_to_uuid(value)


# Removes a $ref when a scalar const already completely determines the value.
def simplify_scalar_const_references(node):
    if isinstance(node, dict):
        if "$ref" in node and isinstance(node.get("const"), (str, int, float, bool)):
            node.pop("$ref")
        for value in node.values():
            simplify_scalar_const_references(value)

        alternatives = node.get("allOf")
        if isinstance(alternatives, list):
            constant = next(
                (
                    alternative["const"]
                    for alternative in alternatives
                    if isinstance(alternative, dict)
                    and isinstance(alternative.get("const"), (str, int, float, bool))
                ),
                None,
            )
            if constant is not None:
                node.clear()
                node["const"] = constant
    elif isinstance(node, list):
        for value in node:
            simplify_scalar_const_references(value)


# Replace the unsupported UUID and Category intersection with UUID
def simplify_partition_allocation(definitions):
    definitions["PartitionAllocationValue"]["properties"]["value"] = ref("UUID")


# Replace semantic aliases that are structurally identical to UUID (Like ActorReference)
def collapse_uuid_aliases(schema, definitions):
    aliases = [name for name, definition in definitions.items() if definition == ref("UUID")]

    for name in aliases:
        replace_ref(schema, ref_path(name), ref_path("UUID"))
        definitions.pop(name)


# Rely on Pydantic to forbid extra fields automatically
def remove_object_closedness(node):
    if isinstance(node, dict):
        if node.get("additionalProperties") is False:
            node.pop("additionalProperties")
        if node.get("unevaluatedProperties") is False:
            node.pop("unevaluatedProperties")
        for value in node.values():
            remove_object_closedness(value)
    elif isinstance(node, list):
        for value in node:
            remove_object_closedness(value)


### Better naming


# Converts each probability distribution into a complete standalone object schema
def materialize_distributions(definitions):
    identity_ref = ref_path("StandardDistributionIdentity")

    for name, definition in list(definitions.items()):
        if definition.get("$ref") != identity_ref:
            continue

        properties = definition["properties"]
        parameters_name = f"{name}Parameters"
        probonto_name = f"{name}ProbOntoId"

        name_property_schema(definitions, name, "parameters", parameters_name)
        probonto = name_property_schema(definitions, name, "probontoId", probonto_name)

        probonto["required"] = ["name", "uri"]
        properties["uncertaintyType"] = {"const": "probabilityDistribution"}

        definition.clear()
        definition.update(
            object_schema(
                properties,
                ["distributionName", "parameters", "probontoId", "uncertaintyType"],
            )
        )

    definitions.pop("StandardDistributionIdentity", None)
    definitions.pop("ProbontoId", None)


# Combines SingleCategory with each property-specific category constraint
def materialize_fixed_categories(definitions):
    base = definitions["SingleCategory"]
    category_refs = {
        ref_path("Category"),
        ref_path("SingleCategory"),
    }

    for value_name, definition in list(definitions.items()):
        value_property = definition.get("properties", {}).get("value")
        if not isinstance(value_property, dict):
            continue

        # A plain Category reference has no property-specific value constraint
        # left to materialize. The fixed category system now belongs to the
        # containing property value rather than to the Category object.
        if value_property in (ref("Category"), ref("SingleCategory")):
            continue

        alternatives = value_property.get("allOf")
        if alternatives is not None:
            if not any(
                isinstance(alternative, dict)
                and alternative.get("$ref") in category_refs
                for alternative in alternatives
            ):
                continue
            constraint = next(
                (
                    alternative
                    for alternative in alternatives
                    if alternative.get("$ref") not in category_refs
                ),
                None,
            )
            if constraint is None:
                continue
        elif value_property.get("$ref") in category_refs:
            constraint = value_property
        else:
            continue

        if not value_name.endswith("Value"):
            raise ValueError(f"Cannot name materialized category for {value_name}")
        category_name = value_name.removesuffix("Value")
        if not category_name.endswith("Category"):
            category_name += "Category"

        category = merge_object_schemas(base, constraint)
        label = category["properties"].get("label")
        if (
            isinstance(label, dict)
            and "anyOf" in label
            and any(
                keyword in label
                for keyword in ("$ref", "const", "enum", "pattern", "type")
            )
        ):
            # CUE emits the property-specific label constraint alongside the
            # generic string-or-boolean base. This is an intersection, not a
            # Pydantic union; the specific constraint already narrows the base.
            label.pop("anyOf")

        definitions[category_name] = category
        definition["properties"]["value"] = ref(category_name)


# Flatten fixed entry lists so datamodel-codegen preserves their positions
def materialize_fixed_category_entries(definitions):
    for system_name, definition in list(definitions.items()):
        properties = definition.get("properties", {})
        entries = properties.get("entries", {})
        alternatives = entries.get("allOf")
        if alternatives is None:
            continue

        prefix = next(
            (
                alternative["prefixItems"]
                for alternative in alternatives
                if "prefixItems" in alternative
            ),
            None,
        )
        if prefix is None:
            continue

        entry_refs = []
        entry_prefix = system_name.removesuffix("CategorySystem")
        for index, entry in enumerate(prefix, 1):
            entry_name = f"{entry_prefix}CategoryEntry{index}"
            entry["required"] = ["label"]
            definitions[entry_name] = entry
            entry_refs.append(ref(entry_name))

        properties["entries"] = {
            "type": "array",
            "prefixItems": entry_refs,
            "items": False,
            "minItems": len(entry_refs),
            "maxItems": len(entry_refs),
        }


# Replace complex constants with named schemas
def materialize_named_complex_consts(definitions):
    dimensionalities = {
        "VolumeDimensionality": {"length": 3},
        "MassDimensionality": {"mass": 1},
        "EnergyDimensionality": {"length": 2, "mass": 1, "time": -2},
    }

    transformations = {
        "DensityUnitTransformation": ("VolumeDimensionality", "MassDimensionality"),
        "EnergyContentUnitTransformation": ("MassDimensionality", "EnergyDimensionality"),
    }

    transformation_fields = {
        "DensityValue": "DensityUnitTransformation",
        "EnergyContentValue": "EnergyContentUnitTransformation",
    }

    definitions["ReviewActivityType"] = object_schema(
        {"typeSystem": {"const": "standard"}, "value": {"const": "dataReview"}}
    )

    for name, dimensionality in dimensionalities.items():
        definitions[name] = object_schema(
            {dimension: {"const": exponent} for dimension, exponent in dimensionality.items()}
        )

    for name, (from_name, to_name) in transformations.items():
        definitions[name] = object_schema({"from": ref(from_name), "to": ref(to_name)})

    for value_name, transformation_name in transformation_fields.items():
        definitions[value_name]["properties"]["unitTransformation"] = ref(transformation_name)


# Moves selected inline property schemas into named definitions (in $defs)
def name_inline_properties(definitions):
    properties = {
        ("ExtensionPropertyRegistry", "type"): "PropertyType",
        ("ComplianceDeclaration", "status"): "ComplianceStatus",
    }

    for (owner_name, property_name), schema_name in properties.items():
        name_property_schema(definitions, owner_name, property_name, schema_name)


# Takes alternatives from anyOf, gives a name and changes the union to reference the names
def name_union_alternatives(definitions, union_name, alternative_names):
    alternatives = definitions[union_name]["anyOf"]
    if len(alternatives) != len(alternative_names):
        raise ValueError(f"Unexpected number of alternatives in {union_name}")

    for name, alternative in zip(alternative_names, alternatives):
        definitions[name] = alternative
    definitions[union_name]["anyOf"] = [ref(name) for name in alternative_names]


# Gives meaningful names to external uncertainty field alternatives
def name_external_uncertainty_fields(definitions):
    name_union_alternatives(
        definitions,
        "ExternalUncertaintyField",
        ("RasterBandUncertaintyField", "DataColumnUncertaintyField", "DataPathUncertaintyField")
    )


# Gives meaningful names to hash alternatives and their algorithms
def name_hash_schemas(definitions):
    name_union_alternatives(definitions, "Hash", ("StandardHash", "OtherHash"))

    algorithm = name_property_schema(
        definitions,
        "StandardHash",
        "algorithm",
        "StandardHashAlgorithm",
    )
    constant = algorithm["const"]
    algorithm.clear()
    algorithm.update(
        object_schema(
            {
                key: {"const": value}
                for key, value in constant.items()
            }
        )
    )

    name_property_schema(definitions, "OtherHash", "algorithm", "OtherHashAlgorithm")


# Name entries that rely on the not operator and have to use validators
def name_negative_alternatives(definitions):
    alternatives = {
        "NonReviewActivityType": ( "StandardNonReviewActivityIdentity", "OtherNonReviewActivityIdentity"),
        "ReviewType": ("ILCDReviewType", "OtherReviewType"),
    }

    for union_name, alternative_names in alternatives.items():
        name_union_alternatives(definitions, union_name, alternative_names)


### Workflow


# Prepare canonical JSON Schema for Pydantic generation
def prepare_schema(schema):
    schema["title"] = "LCADataSet"
    definitions = schema["$defs"]
    definitions["NonEmptyString"] = {"type": "string", "minLength": 1}

    renames = {
        "StandardPropertyForJSONSchema": "StandardPropertyValue",
        "StandardPropertyRegistryForJSONSchema": "StandardPropertyRegistry",
    }

    for old_name, new_name in renames.items():
        rename_definition(schema, definitions, old_name, new_name)

    add_discriminator(definitions["StandardPropertyValue"], "property", definitions)
    prepare_standard_registry(definitions)

    extension_ids_to_uuid(schema)
    materialize_distributions(definitions)
    materialize_fixed_categories(definitions)
    materialize_fixed_category_entries(definitions)
    materialize_named_complex_consts(definitions)
    name_inline_properties(definitions)
    name_external_uncertainty_fields(definitions)
    name_hash_schemas(definitions)
    simplify_partition_allocation(definitions)
    collapse_uuid_aliases(schema, definitions)
    name_negative_alternatives(definitions)
    simplify_scalar_const_references(schema)
    remove_object_closedness(schema)

    definitions.pop("ExtensionCategoryId", None)
    definitions.pop("ExtensionPropertyId", None)


def main():
    if len(sys.argv) != 2:
        raise SystemExit("Usage: prepare_pydantic_schema.py SCHEMA.json")

    path = sys.argv[1]
    with open(path, encoding="utf-8") as file:
        schema = json.load(file)

    prepare_schema(schema)

    output_path = path.replace("lca.schema.json", "lca_pydantic.schema.json")
    with open(output_path, "w", encoding="utf-8") as file:
        json.dump(schema, file, indent=4, ensure_ascii=False)

    print("Created Pydantic JSON Schema.")


if __name__ == "__main__":
    main()

