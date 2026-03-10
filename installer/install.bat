@echo off
setlocal EnableDelayedExpansion
title Launcher Daemon - Setup

REM Installer runs from installer/ folder; app files are in parent
set "INSTALLER_DIR=%~dp0"
cd /d "%~dp0.."
set "APP_DIR=%cd%"

REM Always copy to permanent location (stable path for startup, survives Downloads cleanup)
set "INSTALL_DIR=%LOCALAPPDATA%\LauncherDaemon"
echo Copying to permanent location: %INSTALL_DIR%
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
xcopy "%APP_DIR%\*" "%INSTALL_DIR%\" /E /Y /Q >nul 2>&1
set "APP_DIR=%INSTALL_DIR%"
cd /d "%APP_DIR%"

echo.
echo ============================================
echo   Launcher Daemon - Setup
echo ============================================
echo.

REM --- Step 1: Check for Python ---
echo [1/4] Checking for Python...
set "PYTHON_EXE="
where python >nul 2>&1
if %errorlevel% equ 0 (
    for /f "delims=" %%i in ('where python 2^>nul') do (set "PYTHON_EXE=%%i" & goto :python_found)
)
where py >nul 2>&1
if %errorlevel% equ 0 (
    set "PYTHON_EXE=py"
    set "PYTHON_ARGS=-3"
    goto :python_found
)

REM Python not found - download and install
echo       Python not found. Downloading Python 3.12...
set "PYTHON_URL=https://www.python.org/ftp/python/3.12.7/python-3.12.7-amd64.exe"
set "PYTHON_INSTALLER=%TEMP%\python-3.12.7-amd64.exe"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; " ^
    "Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%PYTHON_INSTALLER%' -UseBasicParsing } " ^
    "catch { Write-Host 'Download failed:' $_.Exception.Message; exit 1 }"
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Could not download Python. Check your internet connection.
    echo Manual: Download from https://www.python.org/downloads/
    pause
    exit /b 1
)

echo       Installing Python (silent - no clicks needed)...
start /wait "" "%PYTHON_INSTALLER%" /passive InstallAllUsers=0 PrependPath=1 Include_test=0
del "%PYTHON_INSTALLER%" 2>nul

REM Find newly installed Python - poll for up to 60 seconds (installer may spawn subprocesses)
echo       Waiting for Python to be ready...
set "PYTHON_EXE="
set "RETRIES=0"
:find_python_loop
set /a RETRIES+=1
if exist "%LOCALAPPDATA%\Programs\Python\Python312\python.exe" (
    set "PYTHON_EXE=%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
    goto :python_found
)
for /d %%d in ("%LOCALAPPDATA%\Programs\Python\Python3*") do (
    if exist "%%d\python.exe" (
        set "PYTHON_EXE=%%d\python.exe"
        goto :python_found
    )
)
if %RETRIES% lss 12 (
    timeout /t 5 /nobreak >nul
    goto find_python_loop
)
echo ERROR: Python was installed but could not be found.
echo Try running this installer again - Python may need a moment to finish.
pause
exit /b 1

:python_found
echo       Python found: %PYTHON_EXE%
REM Add Python to PATH for this session (newly installed Python not in current PATH yet)
for %%a in ("%PYTHON_EXE%") do set "PYTHON_DIR=%%~dpa"
set "PATH=%PYTHON_DIR%;%PYTHON_DIR%Scripts;%PATH%"
echo.

REM --- Step 2: Install pip dependencies ---
echo [2/4] Installing dependencies...
if "%PYTHON_ARGS%"=="" (
    "%PYTHON_EXE%" -m pip install --upgrade pip --quiet 2>nul
    "%PYTHON_EXE%" -m pip install -r requirements.txt --quiet
) else (
    %PYTHON_EXE% %PYTHON_ARGS% -m pip install --upgrade pip --quiet 2>nul
    %PYTHON_EXE% %PYTHON_ARGS% -m pip install -r requirements.txt --quiet
)
if %errorlevel% neq 0 (
    echo       Trying without --quiet...
    if "%PYTHON_ARGS%"=="" (
        "%PYTHON_EXE%" -m pip install -r requirements.txt
    ) else (
        %PYTHON_EXE% %PYTHON_ARGS% -m pip install -r requirements.txt
    )
)
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies.
    pause
    exit /b 1
)
echo       Dependencies installed.
echo.

REM --- Step 3: Add to startup (Registry Run - no admin needed, most reliable) ---
echo [3/4] Adding to Windows startup...
REM Remove old methods
schtasks /delete /tn "Launcher Daemon" /f >nul 2>&1
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%STARTUP_FOLDER%\Launcher Daemon.lnk" del "%STARTUP_FOLDER%\Launcher Daemon.lnk"
REM Registry Run key - runs at logon, no admin required, works for all users
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Launcher Daemon" /t REG_SZ /d "\"%APP_DIR%\start_server.bat\"" /f
echo       Added to startup.
echo.

REM --- Step 4: Start the daemon ---
echo [4/4] Starting Launcher Daemon...
call "%APP_DIR%\run_daemon.bat"

echo.
echo ============================================
echo   Setup complete!
echo ============================================
echo.
echo Daemon running on http://localhost:8765
echo Will start automatically when you log in.
echo.
timeout /t 3 /nobreak >nul
