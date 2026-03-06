@echo off
REM Launcher Daemon - runs detached in background on localhost:8765
REM Uses Python subprocess.DETACHED_PROCESS so daemon survives when window closes
cd /d "%~dp0"

where python >nul 2>&1
if %errorlevel% neq 0 (
    where py >nul 2>&1
    if %errorlevel% neq 0 (
        echo Python not found. Install Python and add it to PATH.
        echo Or run run_daemon_visible.bat to debug.
        pause
        exit /b 1
    )
    py -3 launch_daemon.py
) else (
    python launch_daemon.py
)
