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

## Run at Windows Startup

To run the daemon automatically when Windows starts:

1. Press `Win+R`, type `shell:startup`, Enter
2. Create a shortcut to `pythonw.exe` with argument: `"C:\path\to\launcher-app-demon\main.py"`
3. Or use Task Scheduler to run `python main.py` at logon

## API

- **GET /launch?url=\<path\>** — Open file with default app. Returns `{"ok": true, "path": "..."}` or `{"ok": false, "error": "..."}`.
- **GET /health** — Health check. Returns `{"ok": true, "status": "running"}`.

## Logs

Logs are written to: `%TEMP%\launcher_daemon.log`

## Requirements

- Windows 10/11
- Python 3.8+
