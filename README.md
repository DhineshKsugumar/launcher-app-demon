# Launcher Daemon

A Python daemon that runs in the background on Windows and opens local files with their default application via `Start-Process`. Accepts HTTP requests with a file path in the URL query parameter.

**For users:** Download the setup ZIP, extract, and run **`installer\install.bat`** – installs Python if needed, starts daemon, adds to startup.

## Quick Start

### For end users (Windows)

1. Download **LauncherDaemon-Setup.zip** from [GitHub Actions](https://github.com/DhineshKsugumar/launcher-app-demon/actions)
2. Extract and double-click **`installer\install.bat`**
3. Done – installs Python if needed, dependencies, starts daemon, adds to startup. No prompts.

### For testing (clean slate)

Run **`uninstall\uninstall.bat`** to remove everything, then re-run the installer to test fresh install.

### Manual setup

```bash
pip install -r requirements.txt
python main.py
```

The server starts on `http://127.0.0.1:8765` by default.

### Launch a file

Open in browser or call via HTTP:

```
http://localhost:8765/launch?url=Z:/dhinesh/app.txt
```

The file opens in its default application (e.g. Notepad for .txt, PDF reader for .pdf).

## Configuration

| Environment Variable | Default   | Description        |
|---------------------|-----------|--------------------|
| `LAUNCHER_PORT`     | `8765`    | HTTP server port   |
| `LAUNCHER_HOST`     | `127.0.0.1` | Bind address     |

## Accepted URL Formats

| Format   | Example                          |
|----------|----------------------------------|
| Raw path | `?url=Z:/dhinesh/app.txt`        |
| With spaces | `?url=Z:/path/My%20File.pdf`  |
| file://  | `?url=file:///Z:/dhinesh/app.txt` |
| mbvr://  | `?url=mbvr://Z:/dhinesh/app.txt`  |

## Running the Daemon

- **`run_daemon.bat`** — Double-click to start in background (no console). Uses Python's `DETACHED_PROCESS` so the daemon **stays running** after the window closes.

## Run at Windows Startup

The installer adds the daemon to Task Scheduler so it starts automatically at logon. No extra steps needed.

To remove: run `uninstall\uninstall.bat` or `schtasks /delete /tn "Launcher Daemon" /f`

## API

- **GET /launch?url=\<path\>** — Open file with default app. Returns `{"ok": true, "path": "..."}` or `{"ok": false, "error": "..."}`.
- **GET /health** — Health check. Returns `{"ok": true, "status": "running"}`.

## Logs

- **Daemon:** `%TEMP%\launcher_daemon.log` – startup, file opens, errors
- **Startup:** `%TEMP%\launcher_daemon_startup.log` – Task Scheduler/VBS launcher (for debugging)

## Requirements

- Windows 10/11
- Python 3.8+
