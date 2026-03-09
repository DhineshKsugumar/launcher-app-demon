# Launcher Daemon Installer

## For users: Two ways to run

### Option A: LauncherDaemon-Setup.zip (recommended – full installer)

1. Download **`LauncherDaemon-Setup.zip`** from GitHub Actions
2. Extract the zip
3. Double-click **`installer\install.bat`**
4. Follow prompts: installs Python if needed, pip deps, starts daemon, adds to startup

### Option B: LauncherDaemon.exe (standalone – no Python needed)

Get **`LauncherDaemon.exe`** and double-click it. The daemon runs immediately. Keep the console window open (minimize it).

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
