@echo off
REM Launcher Daemon - runs detached in background on localhost:8765
REM Uses Python subprocess.DETACHED_PROCESS so daemon survives when window closes
cd /d "%~dp0"

REM Check known Python location first (works at startup when PATH may not be ready)
set "PYTHON_EXE="
if exist "%LOCALAPPDATA%\Programs\Python\Python312\python.exe" (
    set "PYTHON_EXE=%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
)
if not defined PYTHON_EXE (
    for /d %%d in ("%LOCALAPPDATA%\Programs\Python\Python3*") do (
        if exist "%%d\python.exe" (set "PYTHON_EXE=%%d\python.exe" & goto :run)
    )
)
if not defined PYTHON_EXE (
    where python >nul 2>&1
    if %errorlevel% equ 0 (
        for /f "delims=" %%i in ('where python 2^>nul') do (set "PYTHON_EXE=%%i" & goto :run)
    )
)
if not defined PYTHON_EXE (
    where py >nul 2>&1
    if %errorlevel% equ 0 (
        py -3 launch_daemon.py
        goto :eof
    )
    echo Python not found. Run installer\install.bat first.
    pause
    exit /b 1
)
:run
"%PYTHON_EXE%" launch_daemon.py
