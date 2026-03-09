#!/bin/bash
# Build LauncherDaemon.exe on Mac using Docker + Wine
# Requires: Docker Desktop installed and running
# Run from project root: ./build_exe_docker.sh

set -e
cd "$(dirname "$0")"

echo "Building LauncherDaemon.exe on Mac via Docker..."
echo ""

# Use kivy/python-winpython image (has Wine + Python + PyInstaller)
IMAGE="kivy/python-winpython:3.9"

# Pull image if needed
docker pull "$IMAGE" 2>/dev/null || true

# Run PyInstaller inside container
docker run --rm \
  -v "$(pwd):/app" \
  -w /app \
  "$IMAGE" \
  bash -c "
    pip install -q -r requirements.txt
    pip install -q pyinstaller
    pyinstaller --clean launcher_daemon.spec
  "

if [ -f "dist/LauncherDaemon.exe" ]; then
  echo ""
  echo "Done! Created: dist/LauncherDaemon.exe"
  echo "Share this file with Windows users - they double-click to run the daemon."
else
  echo "Build failed - check output above"
  exit 1
fi
