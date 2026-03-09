# Launcher Daemon Installer

For **non-technical users** – one-click setup that installs Python (if needed), dependencies, and runs the daemon.

## Option 1: Run install.bat (simplest)

1. Get the Launcher Daemon folder (zip or clone)
2. Double-click **`install.bat`** (inside the `installer` folder)
3. Follow the prompts:
   - If Python is missing, the installer will download it – click **Next, Next** in the Python installer
   - Choose whether to add to Windows startup (Y/N)
   - The daemon starts automatically

## Option 2: Build a single .exe (for distribution)

On a Windows machine, run:

```
installer\build_exe.bat
```

This creates **`LauncherDaemon-Setup.exe`** in the project folder. Distribute this single file to users – they double-click it to install everything.

If the .exe build fails, it will create **`LauncherDaemon-Setup.zip`** instead. Users extract the zip and run `installer\install.bat`.

## What the installer does

1. **Checks for Python** – if not found, downloads Python 3.12 and runs the installer (user clicks Next)
2. **Installs dependencies** – `pip install -r requirements.txt`
3. **Asks about startup** – optionally adds the daemon to run at Windows logon
4. **Starts the daemon** – runs in the background on http://localhost:8765
