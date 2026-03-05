#!/usr/bin/env python3
"""
Launcher Daemon - HTTP server that opens local files with default app via Start-Process.
Runs in background on Windows. Accepts: GET /launch?url=<file_path>

Example: http://localhost:8765/launch?url=Z:/dhinesh/app.txt
"""

import os
import subprocess
import sys
from pathlib import Path
from typing import Optional
from urllib.parse import unquote, urlparse

if sys.platform != "win32":
    sys.exit("This daemon is for Windows only.")

from fastapi import FastAPI, Query
from uvicorn import run

app = FastAPI(title="Launcher Daemon", version="1.0.0")

# Default port
DEFAULT_PORT = 8765
LOG_PATH = Path(os.environ.get("TEMP", os.environ.get("TMP", "."))) / "launcher_daemon.log"


def log(message: str) -> None:
    """Write message to log file."""
    try:
        with open(LOG_PATH, "a", encoding="utf-8") as f:
            f.write(f"{message}\n")
    except OSError:
        pass


def parse_file_path(url_param: str) -> Optional[str]:
    """
    Parse file path from URL query parameter.
    Supports: raw path (Z:/dhinesh/app.txt), file://, mbvr://
    """
    if not url_param or not url_param.strip():
        return None

    s = url_param.strip().strip('"').strip("'")

    # URL-decode first (handles %20, %3A, etc.)
    try:
        s = unquote(s)
    except Exception as e:
        log(f"URL decode error: {e}")
        return None

    s = s.strip()
    if not s:
        return None

    # Handle mbvr:// prefix
    if s.lower().startswith("mbvr://"):
        s = s[7:]
    # Handle file:// or file:///
    elif s.lower().startswith("file:///"):
        s = s[8:]
    elif s.lower().startswith("file://"):
        s = s[7:]
    elif s.lower().startswith("file:"):
        s = s[5:]

    s = s.strip()
    if not s:
        return None

    # If it looks like a URL (e.g. http://), reject - we only open local paths
    parsed = urlparse(s)
    if parsed.scheme and parsed.scheme.lower() not in ("", "file"):
        log(f"Rejected non-local URL scheme: {parsed.scheme}")
        return None

    # Normalize path separators for Windows
    return s.replace("/", "\\")


def open_with_default_app(file_path: str) -> bool:
    """Open file with default application using Start-Process (PowerShell)."""
    try:
        escaped = file_path.replace("'", "''")
        cmd = ["powershell", "-NoProfile", "-Command", f"Start-Process -FilePath '{escaped}'"]
        creationflags = getattr(subprocess, "CREATE_NO_WINDOW", 0x08000000)
        subprocess.Popen(cmd, creationflags=creationflags)
        log(f"Opened: {file_path}")
        return True
    except OSError as e:
        log(f"Failed to open: {e}")
        return False


@app.get("/launch")
def launch(url: str = Query(..., description="File path to open (e.g. Z:/dhinesh/app.txt)")):
    """
    Open a local file with its default application.
    Query param: url - file path (raw, file://, or mbvr://)
    """
    file_path = parse_file_path(url)
    if not file_path:
        log(f"Failed to parse url param: {url[:100]}")
        return {"ok": False, "error": "Invalid or missing file path"}

    if open_with_default_app(file_path):
        return {"ok": True, "path": file_path}
    return {"ok": False, "error": "Failed to launch"}


@app.get("/health")
def health():
    """Health check endpoint."""
    return {"ok": True, "status": "running"}


def main():
    port = int(os.environ.get("LAUNCHER_PORT", DEFAULT_PORT))
    host = os.environ.get("LAUNCHER_HOST", "127.0.0.1")
    log(f"Launcher daemon starting on {host}:{port}")
    run(app, host=host, port=port, log_level="warning")


if __name__ == "__main__":
    main()
