@echo off
REM Launcher Daemon - runs in background (no console window)
REM Uses pythonw.exe to avoid showing a terminal
cd /d "%~dp0"
pythonw main.py
