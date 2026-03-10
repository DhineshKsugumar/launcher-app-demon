@echo off
REM Launcher Daemon - Start server at logon (Registry Run / Startup)
REM Use absolute path: cd to script dir (%~dp0 works even when started from Registry)
cd /d "%~dp0"

REM Log that we ran (for debugging - check %TEMP%\launcher_daemon_startup.log)
echo [%date% %time%] start_server.bat started, cd=%cd% >> "%TEMP%\launcher_daemon_startup.log" 2>nul

REM Wait for system/profile to be ready at logon
timeout /t 15 /nobreak >nul

REM Find pythonw.exe - full path only (PATH not ready at logon)
set "PYTHONW="
if exist "%LOCALAPPDATA%\Programs\Python\Python312\pythonw.exe" (
    set "PYTHONW=%LOCALAPPDATA%\Programs\Python\Python312\pythonw.exe"
)
if not defined PYTHONW (
    for /d %%d in ("%LOCALAPPDATA%\Programs\Python\Python3*") do (
        if exist "%%d\pythonw.exe" (
            set "PYTHONW=%%d\pythonw.exe"
            goto :found
        )
    )
)
if not defined PYTHONW (
    echo [%date% %time%] Python not found >> "%TEMP%\launcher_daemon_startup.log" 2>nul
    exit /b 1
)
:found

REM Run launch_daemon.py (spawns detached process, no console)
"%PYTHONW%" launch_daemon.py
echo [%date% %time%] Launched daemon >> "%TEMP%\launcher_daemon_startup.log" 2>nul
exit /b 0
