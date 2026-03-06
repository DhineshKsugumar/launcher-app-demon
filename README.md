# Launcher Daemon

A Python daemon that runs in the background on Windows and opens local files with their default application via `Start-Process`. Accepts HTTP requests with a file path in the URL query parameter.

Similar to the [windows-launcher-vr](https://github.com/...) mbvr:// protocol launcher, but uses an HTTP endpoint instead of a custom URL protocol.

## Quick Start

### 1. Install dependencies

```bash
pip install -r requirements.txt
```

### 2. Run the daemon

```bash
python main.py
```

The server starts on `http://127.0.0.1:8765` by default.

### 3. Launch a file

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

- **`run_daemon.bat`** — Double-click to start in background (no console). Uses PowerShell Start-Process so the daemon stays running after the window closes. Tries `pythonw`, then `py -3`, then `python`.
- **`run_daemon_visible.bat`** — Runs with a visible console (for debugging). Use this if the daemon fails to start.

## Run at Windows Startup

**Option 1: Use `add_to_startup.bat`** (easiest)

Double-click `add_to_startup.bat` once. It creates a shortcut in your Startup folder. The daemon will run automatically every time you log in to Windows.

**Option 2: Manual**

1. Press `Win+R`, type `shell:startup`, Enter
2. Create a shortcut to `run_daemon.bat` in that folder
3. To remove: delete the shortcut from the Startup folder

## API

- **GET /launch?url=\<path\>** — Open file with default app. Returns `{"ok": true, "path": "..."}` or `{"ok": false, "error": "..."}`.
- **GET /health** — Health check. Returns `{"ok": true, "status": "running"}`.

## Logs

Logs are written to: `%TEMP%\launcher_daemon.log`

## Requirements

- Windows 10/11
- Python 3.8+
