#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug  5 09:41:25 2026

@author: jotape42p
"""

import json
from decimal import Decimal
from glob import glob

from pydantic import TypeAdapter, ValidationError
from Lavoisier.conversions.models.lca import LCADataSet


def _invalid_constant(value):
    raise ValueError(f"Invalid JSON numeric constant: {value}")


adapter = TypeAdapter(LCADataSet)
failed = 0
for path in sorted(glob("examples/*.json")):
    with open(path, encoding="utf-8") as file:
        data = json.load(file, parse_float=Decimal, parse_constant=_invalid_constant)

    try:
        dataset = adapter.validate_python(data)
    except ValidationError as error:
        failed += 1
        print(f"\tINVALID: {path}")
        print(error)
        print()
    else:
        print(f"\tVALID: {path} -> {type(dataset).__name__}")

if failed:
    raise SystemExit(f"{failed} example(s) failed validation")

print("All examples passed Pydantic validation.")

