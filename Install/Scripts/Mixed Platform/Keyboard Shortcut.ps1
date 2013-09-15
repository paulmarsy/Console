$consoleShortcutFolder = Join-Path ([Environment]::GetFolderPath("StartMenu")) "_consoleHotkeys"
if (Test-Path $consoleShortcutFolder) {
	Remove-Item $consoleShortcutFolder -Force -Recurse
}
New-Item $consoleShortcutFolder -Type Directory -Force | Out-Null

$WshShell = New-Object -comObject WScript.Shell

"Setting up CTRL+SHIFT+S Shortcut"
$consoleShortcutS = $WshShell.CreateShortcut((Join-Path $consoleShortcutFolder "SConsole.lnk"))
$consoleShortcutS.TargetPath = "$InstallPath\ConEmu\ConEmu.exe"
$consoleShortcutS.Hotkey = "CTRL+SHIFT+S"
$consoleShortcutS.WorkingDirectory = "C:\"
$consoleShortcutS.Save()

"Setting up CTRL+SHIFT+C Shortcut"
$consoleShortcutC = $WshShell.CreateShortcut((Join-Path $consoleShortcutFolder "CConsole.lnk"))
$consoleShortcutC.TargetPath = "$InstallPath\ConEmu\ConEmu.exe"
$consoleShortcutC.Hotkey = "CTRL+SHIFT+C"
$consoleShortcutC.WorkingDirectory = "C:\"
$consoleShortcutC.Save()