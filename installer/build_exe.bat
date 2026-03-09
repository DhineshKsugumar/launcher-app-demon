@echo off
REM Builds LauncherDaemon-Setup.exe using Windows IExpress
REM Run this on Windows from the launcher-app-demon folder
cd /d "%~dp0.."
set "ROOT=%cd%"
cd /d "%ROOT%"
set "STAGE=%TEMP%\LauncherDaemonBuild"
set "OUTPUT=LauncherDaemon-Setup.exe"

echo Building Launcher Daemon Setup...
echo.

REM Clean and create staging
if exist "%STAGE%" rmdir /s /q "%STAGE%"
mkdir "%STAGE%"

REM Copy all app files to stage
copy "%ROOT%\main.py" "%STAGE%\" >nul
copy "%ROOT%\requirements.txt" "%STAGE%\" >nul
copy "%ROOT%\run_daemon.bat" "%STAGE%\" >nul
copy "%ROOT%\launch_daemon.py" "%STAGE%\" >nul
copy "%ROOT%\add_to_startup.bat" "%STAGE%\" >nul
copy "%ROOT%\install_task_scheduler.bat" "%STAGE%\" >nul
mkdir "%STAGE%\installer"
copy "%ROOT%\installer\install.bat" "%STAGE%\installer\" >nul

REM Create SED - IExpress format (SourceFiles points to section with file paths)
set "SED=%STAGE%\setup.sed"
(
echo [Version]
echo Class=IEXPRESS
echo SEDVersion=3
echo.
echo [Options]
echo PackagePurpose=InstallApp
echo ShowInstallProgramWindow=1
echo UseLongFileName=1
echo TargetName=%ROOT%\%OUTPUT%
echo FriendlyName=Launcher Daemon Setup
echo AppLaunched=cmd.exe /c "installer\install.bat"
echo.
echo [Strings]
echo.
echo [SourceFiles]
echo SourceFiles0=%STAGE%
echo.
echo [SourceFiles0]
echo main.py=
echo requirements.txt=
echo run_daemon.bat=
echo launch_daemon.py=
echo add_to_startup.bat=
echo install_task_scheduler.bat=
echo installer\install.bat=
echo.
echo [DestinationDirs]
echo DefaultDestDir=0
echo.
echo [SourceFiles0]
echo main.py=0
echo requirements.txt=0
echo run_daemon.bat=0
echo launch_daemon.py=0
echo add_to_startup.bat=0
echo install_task_scheduler.bat=0
echo installer\install.bat=0
) > "%SED%"

REM IExpress may fail with complex SED - create zip as fallback
echo Running IExpress...
iexpress /N "%SED%" 2>nul
if not exist "%ROOT%\%OUTPUT%" (
    echo.
    echo IExpress build skipped or failed. Creating ZIP instead...
    powershell -NoProfile -Command "Compress-Archive -Path '%STAGE%\*' -DestinationPath '%ROOT%\LauncherDaemon-Setup.zip' -Force"
    echo.
    echo Created: %ROOT%\LauncherDaemon-Setup.zip
    echo User instructions: Extract the zip, then double-click installer\install.bat
) else (
    echo.
    echo Created: %ROOT%\%OUTPUT%
    echo Distribute this .exe - users double-click to install.
)

rmdir /s /q "%STAGE%" 2>nul
echo.
pause
