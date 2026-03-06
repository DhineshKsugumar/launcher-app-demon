@echo off
REM Launcher Daemon - runs detached in background on localhost:8765
REM Uses VBScript so the process survives when this window closes
cd /d "%~dp0"

set PYTHON_CMD=
where pythonw >nul 2>&1
if %errorlevel% equ 0 (
    set PYTHON_CMD=pythonw
    goto :run
)
where py >nul 2>&1
if %errorlevel% equ 0 (
    set PYTHON_CMD=py -3
    goto :run
)
where python >nul 2>&1
if %errorlevel% equ 0 (
    set PYTHON_CMD=python
    goto :run
)

echo Python not found. Install Python and add it to PATH.
echo Or run run_daemon_visible.bat to debug.
pause
exit /b 1

:run
REM VBS runs the daemon truly detached (won't die when this batch exits)
wscript //nologo "%~dp0start_daemon.vbs" "%PYTHON_CMD%"
echo Launcher daemon started on http://localhost:8765
