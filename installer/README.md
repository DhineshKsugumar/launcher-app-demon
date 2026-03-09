# Launcher Daemon Installer

## For users: Two ways to run

### Option A: LauncherDaemon.exe (easiest – no Python needed)

Get **`LauncherDaemon.exe`** and double-click it. The daemon runs immediately. No installation.

### Option B: install.bat (if you have the full folder)

1. Extract the Launcher Daemon folder (from zip)
2. Double-click **`installer\install.bat`**
3. Follow prompts (installs Python if needed, then starts daemon)

---

## For you: Building the EXE

### On Mac (your machine)

**Method 1: Docker** (requires Docker Desktop)
```bash
chmod +x build_exe_docker.sh
./build_exe_docker.sh
```
Output: `dist/LauncherDaemon.exe`

**Method 2: GitHub Actions** (no local setup)
1. Push your code to GitHub
2. Go to Actions → "Build Windows EXE" → Run workflow (or it runs on push to main)
3. Download the `LauncherDaemon-exe` artifact

### On Windows

```bash
build_exe.bat
```
Output: `dist\LauncherDaemon.exe`

### Building the ZIP (alternative distribution)

```bash
installer\build_exe.bat
```
Creates `LauncherDaemon-Setup.zip` – users extract and run `installer\install.bat`

## What the installer does

1. **Checks for Python** – if not found, downloads Python 3.12 and runs the installer (user clicks Next)
2. **Installs dependencies** – `pip install -r requirements.txt`
3. **Asks about startup** – optionally adds the daemon to run at Windows logon
4. **Starts the daemon** – runs in the background on http://localhost:8765
