@echo off
REM Launcher Daemon - runs with visible console (for debugging)
cd /d "%~dp0"

where python >nul 2>&1
if %errorlevel% neq 0 (
    where py >nul 2>&1
    if %errorlevel% equ 0 (
        py -3 main.py
    ) else (
        echo Python not found.
        pause
        exit /b 1
    )
) else (
    python main.py
)
pause
