#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug  5 04:21:44 2026

@author: jotape42p
"""

import sys
import json


### Walk


def walk_schema(schema, correction):
    def walk(node, path=()):
        if isinstance(node, dict):
            correction(node, path)
            for key, value in list(node.items()):
                walk(value, (*path, key))
        elif isinstance(node, list):
            for index, item in enumerate(node):
                walk(item, (*path, index))

    walk(schema)


### Generic corrections


# additionalProperties -> unevaluatedProperties
def change_additional_properties(node, *args):
    if (
        any(keyword in node for keyword in ("$ref", "allOf", "anyOf", "oneOf"))
        and node.get("additionalProperties") is False
    ):
        del node["additionalProperties"]
        node["unevaluatedProperties"] = False


# const + enum
def remove_enums(node, *args):
    if "const" in node and node["const"] in node.get("enum", []):
        del node["enum"]


# Prefix items are equal to items sometimes
def remove_prefix_items(node, *args):
    if "items" in node and node.get("prefixItems") == [node["items"]]:
        del node["prefixItems"]


# Repetition of not statements in allOf
def remove_not_in_all_of(node, *args):
    all_of = node.get("allOf")
    if not isinstance(all_of, list):
        return
    if any(
        not isinstance(item, dict) or set(item) - {"$ref", "not"}
        for item in all_of
    ):
        return

    references = [item["$ref"] for item in all_of if "$ref" in item]
    excluded_values = [
        item["not"]["const"]
        for item in all_of
        if isinstance(item.get("not"), dict) and "const" in item["not"]
    ]
    if len(references) != 1 or len(excluded_values) != len(all_of):
        return

    node.clear()
    node["$ref"] = references[0]
    node["not"] = {"enum": excluded_values}


# Integer + number verification
def remove_number_with_integer(node, *args):
    all_of = node.get("allOf", [])
    if len(all_of) != 2 or {"type": "number"} not in all_of:
        return

    integer = next(
        (
            item
            for item in all_of
            if isinstance(item, dict) and item.get("type") == "integer"
        ),
        None,
    )

    if integer:
        node.clear()
        node.update(integer)


### Specific corrections


# Id of standard properties have additional verifications
def correct_property_ids(schema):
    ids = {}

    def get_ids(node, path):
        if (
            len(path) == 2
            and path[0] == "$defs"
            and isinstance(path[1], str)
            and path[1].endswith(".id")
            and "const" in node
        ):
            ids[path[1]] = node["const"]

    walk_schema(schema, get_ids)

    def correct_ids(node, path):
        all_of = node.get("allOf")

        if isinstance(all_of, list) and len(all_of) == 2:
            refs = [item.get("$ref") for item in all_of if isinstance(item, dict)]

            if "#/$defs/PropertyReference" in refs:
                id_reference = next(
                    (ref for ref in refs if ref != "#/$defs/PropertyReference"),
                    None,
                )

                if isinstance(id_reference, str):
                    id_name = id_reference.removeprefix("#/$defs/")

                    if id_name in ids:
                        node.clear()
                        node["type"] = "string"
                        node["const"] = ids[id_name]
                        return

            if "#/$defs/ExtensionPropertyId" in refs and (
                "#/$defs/PropertyReference" in refs or "#/$defs/UUID" in refs
            ):
                node.clear()
                node["$ref"] = "#/$defs/ExtensionPropertyId"
                return

        reference = node.get("$ref")

        if isinstance(reference, str):
            id_name = reference.removeprefix("#/$defs/")

            if id_name in ids:
                node.clear()
                node["$ref"] = "#/$defs/UUID"
                node["const"] = ids[id_name]

    walk_schema(schema, correct_ids)

    for id_name in ids:
        del schema["$defs"][id_name]

    schema["$defs"].pop("PropertyReference", None)


# Unnecessary distribution name enum
def remove_distribution_name(node, path):
    if path == ():
        node.get("$defs", {}).pop("DistributionName", None)
        return
    if path == ("$defs", "StandardDistributionIdentity"):
        node.setdefault("properties", {})["distributionName"] = {}
        return
    if node.get("$ref") != "#/$defs/StandardDistributionIdentity":
        return

    node.get("properties", {}).pop("uncertaintyType", None)
    if "required" in node:
        node["required"] = [
            field for field in node["required"] if field != "uncertaintyType"
        ]
        if not node["required"]:
            del node["required"]


# Nested anyOf in AnyPropertyRegistry
def correct_any_property_registry(node, path):
    if path != ("$defs", "AnyPropertyRegistry"):
        return

    any_of = node.get("anyOf", [])
    flattened = []
    for item in any_of:
        if isinstance(item, dict) and set(item) == {"anyOf"}:
            flattened.extend(item["anyOf"])
        else:
            flattened.append(item)

    node["anyOf"] = flattened


# Distribution has additional fields already in the generic entry
def remove_distribution_additional_fields(node, *args):
    if node.get("$ref") == "#/$defs/StandardDistributionIdentity":
        node.pop("type", None)
        node.pop("required", None)
        node.pop("unevaluatedProperties", None)


### Main


def main():
    if len(sys.argv) != 2:
        raise SystemExit("Usage: normalize_jsonschema_defs.py SCHEMA.json")

    path = sys.argv[1]
    # path = "./lca.schema.json"
    with open(path, encoding="utf-8") as file:
        schema = json.load(file)

    walk_schema(schema, change_additional_properties)
    walk_schema(schema, remove_enums)
    walk_schema(schema, remove_prefix_items)
    walk_schema(schema, remove_not_in_all_of)
    walk_schema(schema, remove_number_with_integer)
    walk_schema(schema, remove_distribution_name)
    walk_schema(schema, correct_any_property_registry)
    walk_schema(schema, remove_distribution_additional_fields)
    correct_property_ids(schema)

    path = path.replace("lca_raw.schema.json", "lca.schema.json")
    with open(path, "w", encoding="utf-8") as file:
        json.dump(schema, file, indent=4, ensure_ascii=False)

    print("Cleaned JSON Schema.")


if __name__ == "__main__":
    main()
