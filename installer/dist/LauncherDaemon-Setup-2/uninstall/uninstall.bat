@echo off
title Launcher Daemon - Uninstall
echo.
echo ============================================
echo   Launcher Daemon - Uninstall
echo ============================================
echo.

REM --- Step 1: Stop the daemon ---
echo [1/4] Stopping Launcher Daemon...
taskkill /F /IM pythonw.exe 2>nul
taskkill /F /IM python.exe 2>nul
timeout /t 2 /nobreak >nul
echo       Done.
echo.

REM --- Step 2: Remove from startup ---
echo [2/4] Removing from Windows startup...
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "SHORTCUT=%STARTUP_FOLDER%\Launcher Daemon.lnk"
if exist "%SHORTCUT%" (
    del "%SHORTCUT%"
    echo       Removed startup shortcut.
) else (
    echo       No startup shortcut found.
)
echo.

REM --- Step 3: Remove Task Scheduler task if exists ---
echo [3/4] Removing scheduled task...
schtasks /delete /tn "Launcher Daemon" /f 2>nul
echo       Done.
echo.

REM --- Step 4: Remove app folder ---
echo [4/4] Removing Launcher Daemon files...
set "INSTALL_DIR=%LOCALAPPDATA%\LauncherDaemon"
if exist "%INSTALL_DIR%" (
    rmdir /s /q "%INSTALL_DIR%"
    echo       Removed %INSTALL_DIR%
) else (
    echo       App folder not found.
)
echo.

REM --- Optional: Uninstall Python (for clean-slate testing) ---
echo Uninstall Python 3.12? (Use only to test fresh install - removes Python completely)
choice /C YN /M "Uninstall Python"
if %errorlevel% equ 1 (
    echo.
    echo Downloading Python uninstaller...
    set "PYTHON_URL=https://www.python.org/ftp/python/3.12.7/python-3.12.7-amd64.exe"
    set "PYTHON_INSTALLER=%TEMP%\python-3.12.7-amd64.exe"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%PYTHON_INSTALLER%' -UseBasicParsing } catch { exit 1 }"
    if exist "%PYTHON_INSTALLER%" (
        echo Running Python uninstaller...
        start /wait "" "%PYTHON_INSTALLER%" /uninstall /quiet
        del "%PYTHON_INSTALLER%" 2>nul
        echo       Python uninstalled.
    ) else (
        echo       Could not download uninstaller. Remove Python manually from Settings ^> Apps.
    )
) else (
    echo       Skipped. Python kept.
)
echo.
echo ============================================
echo   Uninstall complete
echo ============================================
echo.
pause
