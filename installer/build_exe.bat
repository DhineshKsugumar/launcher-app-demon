@echo off
REM Builds LauncherDaemon-Setup.zip for distribution
REM Run this on Windows from the launcher-app-demon folder
cd /d "%~dp0.."
set "ROOT=%cd%"
set "ZIP=%ROOT%\LauncherDaemon-Setup.zip"

echo Building Launcher Daemon Setup...
echo.

REM Create ZIP with all app files (PowerShell works on all Windows)
powershell -NoProfile -Command ^
    "$root = '%ROOT%'; $zip = '%ZIP%'; " ^
    "$temp = Join-Path $env:TEMP 'LauncherDaemonBuild'; " ^
    "if (Test-Path $temp) { Remove-Item $temp -Recurse -Force }; " ^
    "New-Item -ItemType Directory -Path (Join-Path $temp 'installer') -Force | Out-Null; " ^
    "New-Item -ItemType Directory -Path (Join-Path $temp 'uninstall') -Force | Out-Null; " ^
    "Copy-Item (Join-Path $root 'main.py') $temp; " ^
    "Copy-Item (Join-Path $root 'requirements.txt') $temp; " ^
    "Copy-Item (Join-Path $root 'run_daemon.bat') $temp; " ^
    "Copy-Item (Join-Path $root 'launch_daemon.py') $temp; " ^
    "Copy-Item (Join-Path $root 'add_to_startup.bat') $temp; " ^
    "Copy-Item (Join-Path $root 'install_task_scheduler.bat') $temp; " ^
    "Copy-Item (Join-Path $root 'installer\install.bat') (Join-Path $temp 'installer'); " ^
    "Copy-Item (Join-Path $root 'uninstall\uninstall.bat') (Join-Path $temp 'uninstall'); " ^
    "Compress-Archive -Path (Join-Path $temp '*') -DestinationPath $zip -Force; " ^
    "Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue"

if exist "%ZIP%" (
    echo.
    echo Created: %ZIP%
    echo.
    echo Distribute this ZIP to users. They:
    echo   1. Extract the zip
    echo   2. Double-click installer\install.bat
    echo.
) else (
    echo Failed to create ZIP.
)
pause
