@echo off
REM Build LauncherDaemon.exe on Windows (run PyInstaller)
cd /d "%~dp0"

echo Building LauncherDaemon.exe...
echo.

pip install -q -r requirements.txt
pip install -q pyinstaller
pyinstaller --clean launcher_daemon.spec

if exist "dist\LauncherDaemon.exe" (
    echo.
    echo Done! Created: dist\LauncherDaemon.exe
    echo Share this file - users double-click to run the daemon.
) else (
    echo Build failed.
)
pause
