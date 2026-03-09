# Launcher Daemon Installer

## For users

1. Download **`LauncherDaemon-Setup.zip`** from GitHub Actions
2. Extract the zip
3. Double-click **`installer\install.bat`**
4. Done – no prompts. Installs Python if needed, dependencies, starts daemon, adds to startup.

## For testing: Uninstall (clean slate)

To test a fresh install (no Python, no deps):

1. Double-click **`uninstall\uninstall.bat`**
2. Follow prompts to remove the app and optionally Python
3. Then run `installer\install.bat` again to test from scratch

## Building the setup ZIP

**GitHub Actions:** Push to main → download `LauncherDaemon-Setup` artifact from Actions

**Local (Windows):** Run `installer\build_exe.bat`

## What the installer does

1. **Checks for Python** – if not found, downloads Python 3.12 and runs the installer (user clicks Next)
2. **Installs dependencies** – `pip install -r requirements.txt`
3. **Asks about startup** – optionally adds the daemon to run at Windows logon
4. **Starts the daemon** – runs in the background on http://localhost:8765
