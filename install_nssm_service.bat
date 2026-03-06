@echo off
REM Installs Launcher Daemon as a Windows SERVICE using NSSM
REM Requires: Download NSSM from https://nssm.cc/download (extract nssm.exe)
REM Place nssm.exe in this folder, or in a folder in your PATH
cd /d "%~dp0"

set "LAUNCHER_DIR=%~dp0"
set "LAUNCHER_DIR=%LAUNCHER_DIR:~0,-1%"
set "NSSM=%~dp0nssm.exe"

if not exist "%NSSM%" (
    where nssm >nul 2>&1
    if %errorlevel% neq 0 (
        echo NSSM not found. Download from https://nssm.cc/download
        echo Extract nssm.exe to this folder: %LAUNCHER_DIR%
        echo Or add nssm to your PATH.
        pause
        exit /b 1
    )
    set "NSSM=nssm"
)

where pythonw >nul 2>&1
if %errorlevel% neq 0 (
    echo pythonw not found. Add Python to PATH.
    pause
    exit /b 1
)

for /f "delims=" %%i in ('where pythonw 2^>nul') do (set "PYTHONW=%%i" & goto :got_python)
:got_python
if not defined PYTHONW (
    echo Could not find pythonw path
    pause
    exit /b 1
)

REM Install the service (NSSM needs full path to executable)
"%NSSM%" install "LauncherDaemon" "%PYTHONW%" "%LAUNCHER_DIR%\main.py"
"%NSSM%" set "LauncherDaemon" AppDirectory "%LAUNCHER_DIR%"
"%NSSM%" set "LauncherDaemon" DisplayName "Launcher Daemon"
"%NSSM%" set "LauncherDaemon" Description "Opens local files via http://localhost:8765/launch?url=..."

echo.
echo Service installed. Start it with: net start LauncherDaemon
echo Or: services.msc - find "Launcher Daemon" and start
echo.
echo To remove: nssm remove LauncherDaemon confirm
pause
