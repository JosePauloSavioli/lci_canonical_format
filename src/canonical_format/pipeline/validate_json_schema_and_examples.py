#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug  4 06:25:45 2026

@author: jotape42p
"""

import sys
import json
from pathlib import Path
from jsonschema import Draft202012Validator, FormatChecker


def print_leaf_errors(error):
    def format_path(error):
        return ".".join(str(part) for part in error.absolute_path) or "<root>"
    
    if error.context:
        for child in error.context:
            print_leaf_errors(child)
        return
    print(f"  {format_path(error)}: {error.message}")


def main():
    if len(sys.argv) < 3:
        raise SystemExit("Usage: json_validator_lca_model.py  SCHEMA.json INSTANCE.json...")

    schema_path = Path(sys.argv[1])
    instance_paths = [Path(filename) for filename in sys.argv[2:]]

    schema = json.loads(schema_path.read_text(encoding="utf-8"))
    Draft202012Validator.check_schema(schema)
    print("Validated JSON Schema.")

    validator = Draft202012Validator(schema, format_checker=FormatChecker())
    failed = False
    for instance_path in instance_paths:
        instance = json.loads(instance_path.read_text(encoding="utf-8"))
        errors = list(validator.iter_errors(instance))

        if not errors:
            print(f"\tOK: {instance_path}")
            continue

        failed = True
        print(f"FAILED: {instance_path}")
        for error in errors:
            print_leaf_errors(error)

    raise SystemExit(1 if failed else 0)


if __name__ == "__main__":
    main()
