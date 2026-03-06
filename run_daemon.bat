@echo off
REM Launcher Daemon - runs in background on localhost:8765
cd /d "%~dp0"

REM Try pythonw (no window), then py launcher, then python
where pythonw >nul 2>&1
if %errorlevel% equ 0 (
    start "" pythonw main.py
    goto :started
)
where py >nul 2>&1
if %errorlevel% equ 0 (
    start "" py -3 main.py
    goto :started
)
where python >nul 2>&1
if %errorlevel% equ 0 (
    start "" python main.py
    goto :started
)

echo Python not found. Install Python and add it to PATH.
echo Or run from the folder: python main.py
pause
exit /b 1

:started
echo Launcher daemon started on http://localhost:8765
