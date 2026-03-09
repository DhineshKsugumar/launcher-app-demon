@echo off
REM Adds Launcher Daemon to Windows Startup (runs when you log in)
cd /d "%~dp0"

set "BAT_PATH=%~dp0run_daemon.bat"
set "WORK_DIR=%~dp0"
set "WORK_DIR=%WORK_DIR:~0,-1%"

set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "SHORTCUT=%STARTUP_FOLDER%\Launcher Daemon.lnk"

powershell -NoProfile -Command ^
    "$WshShell = New-Object -ComObject WScript.Shell; " ^
    "$Shortcut = $WshShell.CreateShortcut('%SHORTCUT%'); " ^
    "$Shortcut.TargetPath = '%BAT_PATH%'; " ^
    "$Shortcut.WorkingDirectory = '%WORK_DIR%'; " ^
    "$Shortcut.WindowStyle = 7; " ^
    "$Shortcut.Description = 'Launcher Daemon - opens files via localhost:8765'; " ^
    "$Shortcut.Save(); " ^
    "Write-Host 'Added to Startup. Launcher Daemon will run when you log in.'"

echo.
echo Shortcut created at: %SHORTCUT%
echo Remove it from that folder to stop running at startup.
pause
