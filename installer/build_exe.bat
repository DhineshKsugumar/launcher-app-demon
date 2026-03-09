@echo off
REM Builds LauncherDaemon-Setup.exe using Windows IExpress
REM Run this on Windows from the launcher-app-demon folder
REM NOTE: IExpress fails if paths contain spaces - uses C:\LauncherDaemonBuild
cd /d "%~dp0.."
set "ROOT=%cd%"
set "OUTPUT=LauncherDaemon-Setup.exe"

REM Use path WITHOUT spaces (IExpress fails with spaces)
set "STAGE=%SystemDrive%\LauncherDaemonBuild"

echo Building Launcher Daemon Setup...
echo.

REM Clean and create staging
if exist "%STAGE%" rmdir /s /q "%STAGE%"
mkdir "%STAGE%" 2>nul
if not exist "%STAGE%" (
    echo Cannot create %STAGE% - no write access. Using ZIP only.
    set "USE_ZIP=1"
    set "STAGE=%TEMP%\LauncherDaemonBuild"
    mkdir "%STAGE%" 2>nul
)

REM Copy all app files to stage
copy "%ROOT%\main.py" "%STAGE%\" >nul
copy "%ROOT%\requirements.txt" "%STAGE%\" >nul
copy "%ROOT%\run_daemon.bat" "%STAGE%\" >nul
copy "%ROOT%\launch_daemon.py" "%STAGE%\" >nul
copy "%ROOT%\add_to_startup.bat" "%STAGE%\" >nul
copy "%ROOT%\install_task_scheduler.bat" "%STAGE%\" >nul
mkdir "%STAGE%\installer" 2>nul
copy "%ROOT%\installer\install.bat" "%STAGE%\installer\" >nul

REM Output path - avoid spaces for IExpress
set "OUTPATH=%SystemDrive%\LauncherDaemon-Setup.exe"
if "%USE_ZIP%"=="1" set "OUTPATH=%ROOT%\%OUTPUT%"

REM Create SED - IExpress format (paths must have NO spaces)
set "SED=%STAGE%\setup.sed"
call :write_sed
goto :skip_write_sed
:write_sed
(
echo [Version]
echo Class=IEXPRESS
echo SEDVersion=3
echo [Options]
echo PackagePurpose=InstallApp
echo ShowInstallProgramWindow=1
echo UseLongFileName=1
echo SourceFiles=SourceFiles
echo TargetName=%OUTPATH%
echo FriendlyName=Launcher Daemon Setup
echo AppLaunched=cmd.exe /c "installer\install.bat"
echo [Strings]
echo FILE0=main.py
echo FILE1=requirements.txt
echo FILE2=run_daemon.bat
echo FILE3=launch_daemon.py
echo FILE4=add_to_startup.bat
echo FILE5=install_task_scheduler.bat
echo FILE6=install.bat
echo [SourceFiles]
echo SourceFiles0=%STAGE%\
echo SourceFiles1=%STAGE%\installer\
echo [SourceFiles0]
echo %%FILE0%%=
echo %%FILE1%%=
echo %%FILE2%%=
echo %%FILE3%%=
echo %%FILE4%%=
echo %%FILE5%%=
echo [SourceFiles1]
echo %%FILE6%%=
) > "%SED%"
goto :eof
:skip_write_sed

REM Run IExpress (use SysWOW64 for x86 exe - works on both 32/64 bit)
if "%USE_ZIP%"=="" (
    echo Running IExpress...
    if exist "%SystemRoot%\SysWOW64\iexpress.exe" (
        "%SystemRoot%\SysWOW64\iexpress.exe" /N "%SED%"
    ) else (
        "%SystemRoot%\System32\iexpress.exe" /N "%SED%"
    )
)

REM Copy exe to project folder if built in different location
if exist "%OUTPATH%" (
    if not "%OUTPATH%"=="%ROOT%\%OUTPUT%" copy "%OUTPATH%" "%ROOT%\%OUTPUT%" >nul
)
if not exist "%ROOT%\%OUTPUT%" (
    echo.
    echo IExpress failed ^(often due to path with spaces^). Creating ZIP instead...
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
if exist "%OUTPATH%" if not "%OUTPATH%"=="%ROOT%\%OUTPUT%" del "%OUTPATH%" 2>nul
echo.
pause
