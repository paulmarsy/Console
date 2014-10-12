Invoke-InstallStep "Setting up Console Start Shortcut" {
	$WshShell = New-Object -ComObject WScript.Shell
	$consoleShortcut = $WshShell.CreateShortcut((Join-Path ([Environment]::GetFolderPath("StartMenu")) "Console.lnk"))
	$consoleShortcut.TargetPath = $conEmuExecutable
	$consoleShortcut.IconLocation = $conEmuPowerShellIcon
	$consoleShortcut.WorkingDirectory = "C:\"
	$consoleShortcut.Save()
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null
}