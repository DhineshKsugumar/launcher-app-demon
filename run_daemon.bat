@echo off
REM Launcher Daemon - runs detached in background on localhost:8765
REM Uses PowerShell Start-Process so the daemon survives when this window closes
cd /d "%~dp0"

set "WORK_DIR=%~dp0"
set "WORK_DIR=%WORK_DIR:~0,-1%"

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
REM Start-Process creates an independent process that survives when batch exits
REM Use cmd /c so the daemon runs in a detached process (not tied to wscript/batch)
powershell -NoProfile -Command "Start-Process -FilePath 'cmd.exe' -ArgumentList '/c','%PYTHON_CMD% main.py' -WorkingDirectory '%WORK_DIR%' -WindowStyle Hidden"
echo Launcher daemon started on http://localhost:8765
