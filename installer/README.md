# Launcher Daemon Installer

For **non-technical users** – one-click setup that installs Python (if needed), dependencies, and runs the daemon.

## Option 1: Run install.bat (simplest)

1. Get the Launcher Daemon folder (zip or clone)
2. Double-click **`install.bat`** (inside the `installer` folder)
3. Follow the prompts:
   - If Python is missing, the installer will download it – click **Next, Next** in the Python installer
   - Choose whether to add to Windows startup (Y/N)
   - The daemon starts automatically

## Option 2: Build for distribution

On a Windows machine, run:

```
installer\build_exe.bat
```

This tries to create **`LauncherDaemon-Setup.exe`** (requires write access to `C:\`). If that fails, it creates **`LauncherDaemon-Setup.zip`** instead.

- **Exe**: Distribute the single file – users double-click to install.
- **Zip**: Users extract the zip and run `installer\install.bat`.

## What the installer does

1. **Checks for Python** – if not found, downloads Python 3.12 and runs the installer (user clicks Next)
2. **Installs dependencies** – `pip install -r requirements.txt`
3. **Asks about startup** – optionally adds the daemon to run at Windows logon
4. **Starts the daemon** – runs in the background on http://localhost:8765
