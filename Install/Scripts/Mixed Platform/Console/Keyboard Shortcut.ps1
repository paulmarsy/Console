$consoleShortcutFolder = Join-Path ([Environment]::GetFolderPath("StartMenu")) "_consoleHotkeys"
if (Test-Path $consoleShortcutFolder) {
	Remove-Item $consoleShortcutFolder -Force -Recurse
}
New-Item $consoleShortcutFolder -Type Directory -Force | Out-Null

$WshShell = New-Object -ComObject WScript.Shell

Invoke-InstallStep "Setting up Console CTRL+SHIFT+S Shortcut" {
	$consoleShortcutS = $WshShell.CreateShortcut((Join-Path $consoleShortcutFolder "Console-Ctrl-Shft-S.lnk"))
	$consoleShortcutS.TargetPath = $conEmuExecutable
	$consoleShortcutS.IconLocation = $conEmuIcon
	$consoleShortcutS.Hotkey = "CTRL+SHIFT+S"
	$consoleShortcutS.WorkingDirectory = "C:\"
	$consoleShortcutS.Save()
}

Invoke-InstallStep "Setting up Console CTRL+SHIFT+C Shortcut" {
	$consoleShortcutC = $WshShell.CreateShortcut((Join-Path $consoleShortcutFolder "Console-Ctrl-Shft-C.lnk"))
	$consoleShortcutC.TargetPath = $conEmuExecutable
	$consoleShortcutC.IconLocation = $conEmuIcon
	$consoleShortcutC.Hotkey = "CTRL+SHIFT+C"
	$consoleShortcutC.WorkingDirectory = "C:\"
	$consoleShortcutC.Save()
}

[System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null