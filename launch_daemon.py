#!/usr/bin/env python3
"""
Launcher for main.py - spawns the daemon as a truly detached process on Windows.
Uses DETACHED_PROCESS so the daemon survives when this script (and any batch) exits.
"""

import os
import subprocess
import sys
from pathlib import Path

if sys.platform != "win32":
    print("This launcher is for Windows only.")
    sys.exit(1)

# Script directory (where main.py lives)
SCRIPT_DIR = Path(__file__).resolve().parent
MAIN_PY = SCRIPT_DIR / "main.py"

# Find pythonw.exe (no console) - usually next to python.exe
python_exe = Path(sys.executable)
pythonw = python_exe.parent / "pythonw.exe"
if not pythonw.exists():
    pythonw = python_exe  # fallback to python (will show console briefly)

# Windows-only: spawn process completely detached from parent
# DETACHED_PROCESS = 0x00000008, CREATE_NEW_PROCESS_GROUP = 0x00000200
DETACHED_PROCESS = 0x00000008
CREATE_NEW_PROCESS_GROUP = 0x00000200

try:
    subprocess.Popen(
        [str(pythonw), str(MAIN_PY)],
        cwd=str(SCRIPT_DIR),
        creationflags=DETACHED_PROCESS | CREATE_NEW_PROCESS_GROUP,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    print("Launcher daemon started on http://localhost:8765")
except OSError as e:
    print(f"Failed to start daemon: {e}")
    sys.exit(1)
