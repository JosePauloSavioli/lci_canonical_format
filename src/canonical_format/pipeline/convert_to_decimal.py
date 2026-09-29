#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug  5 09:41:25 2026

@author: jotape42p
"""

import io
import sys
import tokenize
from pathlib import Path


path = Path(sys.argv[1])
source = path.read_text(encoding="utf-8")
tokens = []
replacements = 0

for token in tokenize.generate_tokens(io.StringIO(source).readline):
    if token.type == tokenize.NAME and token.string == "float":
        token = tokenize.TokenInfo(
            token.type,
            "Decimal",
            token.start,
            token.end,
            token.line,
        )
        replacements += 1
    tokens.append(token)

if replacements == 0:
    raise ValueError("No float annotations were found")

source = tokenize.untokenize(tokens)
if "from decimal import Decimal" not in source:
    marker = "from datetime import date as date_aliased\n"
    source = source.replace(marker, f"{marker}from decimal import Decimal\n", 1)

path.write_text(source, encoding="utf-8")
print(f"Changed {replacements} float annotations to Decimal in {path}")

