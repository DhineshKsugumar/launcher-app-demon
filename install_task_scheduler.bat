@echo off
REM Installs Launcher Daemon to run at Windows logon (Task Scheduler)
REM The daemon will start automatically every time you log in - no window, runs in background
cd /d "%~dp0"

set "LAUNCHER_DIR=%~dp0"
set "LAUNCHER_DIR=%LAUNCHER_DIR:~0,-1%"
set "LAUNCHER_SCRIPT=%LAUNCHER_DIR%\launch_daemon.py"

REM Create task: runs at logon, uses pythonw (no window)
schtasks /create /tn "Launcher Daemon" /tr "pythonw \"%LAUNCHER_SCRIPT%\"" /sc onlogon /f
if %errorlevel% neq 0 (
    echo.
    echo If pythonw not found, trying with full python path...
    where pythonw >nul 2>&1
    if %errorlevel% neq 0 (
        echo Try running: python install_task_scheduler.py
        echo Or add Python to PATH and run this again.
        pause
        exit /b 1
    )
)

echo.
echo Launcher Daemon installed. It will start automatically when you log in.
echo.
echo To remove: schtasks /delete /tn "Launcher Daemon" /f
echo To start now: run_daemon.bat
pause
