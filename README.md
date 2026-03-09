# Launcher Daemon

A Python daemon that runs in the background on Windows and opens local files with their default application via `Start-Process`. Accepts HTTP requests with a file path in the URL query parameter.

Similar to the [windows-launcher-vr](https://github.com/...) mbvr:// protocol launcher, but uses an HTTP endpoint instead of a custom URL protocol.

## Quick Start

### For non-technical users

Double-click **`installer\install.bat`**. It will:
- Install Python if needed (you'll click Next in the Python installer)
- Install dependencies
- Start the daemon
- Optionally add to Windows startup

See `installer/README.md` for building a single `.exe` for distribution.

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

## Run at Windows Startup (Always Running)

**Option 1: Task Scheduler** (recommended, built into Windows)

Double-click `install_task_scheduler.bat`. Creates a scheduled task that runs the daemon at every logon.

To remove: `schtasks /delete /tn "Launcher Daemon" /f`

**Option 2: Startup folder**

Double-click `add_to_startup.bat`. Creates a shortcut in your Startup folder. The daemon runs when you log in.

To remove: Press `Win+R` → `shell:startup` → delete "Launcher Daemon" shortcut.

## API

- **GET /launch?url=\<path\>** — Open file with default app. Returns `{"ok": true, "path": "..."}` or `{"ok": false, "error": "..."}`.
- **GET /health** — Health check. Returns `{"ok": true, "status": "running"}`.

## Logs

Logs are written to: `%TEMP%\launcher_daemon.log`

## Requirements

- Windows 10/11
- Python 3.8+
