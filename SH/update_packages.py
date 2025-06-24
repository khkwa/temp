#!/usr/bin/env python

import sys
import subprocess

packages = [
    "pip",
    "matplotlib",
    "networkx",
    "numpy",
    "pandas",
    "openpyxl", # A Python library to read/write Excel 2010 xlsx/xlsm/xltx/xltm files.
                # See https://openpyxl.readthedocs.io/en/stable/.
    "scipy"
    ]

for package in packages:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "--upgrade", package])
