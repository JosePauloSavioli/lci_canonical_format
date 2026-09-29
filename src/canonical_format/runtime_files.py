#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug  6 21:45:00 2026

@author: jotape42p
"""

from pathlib import Path
from uuid import uuid4

import fiona
import rasterio


class RuntimeFiles:

    def __init__(self, root):
        self.root = Path(root)
        self.output = self.root / "solved_entries"

    def path(self, value):
        path = Path(value)
        return path if path.is_absolute() else self.root / path

    def file(self, value):
        path = self.path(value)
        if not path.is_file():
            raise FileNotFoundError(path)
        return path

    def target(self, source, suffix):
        self.output.mkdir(exist_ok=True)
        return Path("solved_entries") / f"{Path(source).stem}_{uuid4().hex[:12]}{suffix}"

    def relative(self, path):
        return self.path(path).relative_to(self.root).as_posix()

    def open_json(self, value):
        return open(self.file(value), encoding="utf-8-sig")

    def open_csv(self, value, mode="r"):
        path = self.file(value) if "r" in mode else self.path(value)
        return open(
            path, mode, newline="", encoding="utf-8-sig" if "r" in mode else "utf-8"
        )

    def open_raster(self, value, mode="r", **kwargs):
        path = self.file(value) if mode == "r" else self.path(value)
        return rasterio.open(path, mode, **kwargs)

    def open_vector(self, value):
        return fiona.open(self.file(value))

