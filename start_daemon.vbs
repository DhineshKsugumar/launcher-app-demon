' Launcher Daemon - starts main.py detached (survives when batch exits)
' Usage: wscript start_daemon.vbs [python_exe]
' If no arg: uses "pythonw" from PATH. If arg: uses that exe (e.g. full path to pythonw.exe)

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
strScriptDir = objFSO.GetParentFolderName(WScript.ScriptFullName)
objShell.CurrentDirectory = strScriptDir

pythonExe = "pythonw"
If WScript.Arguments.Count > 0 Then
    pythonExe = WScript.Arguments(0)
End If

' Run hidden (0), don't wait (False) - process runs independently
objShell.Run pythonExe & " main.py", 0, False
