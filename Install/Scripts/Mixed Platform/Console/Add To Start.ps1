Invoke-InstallStep "Setting up Console Start Shortcut" {
	$WshShell = New-Object -ComObject WScript.Shell
	$consoleShortcut = $WshShell.CreateShortcut((Join-Path ([Environment]::GetFolderPath("StartMenu")) "Console.lnk"))
	$consoleShortcut.TargetPath = $PowerShellConsoleContstants.Executables.ConEmu
	$consoleShortcut.IconLocation = $conEmuPowerShellIcon
	$consoleShortcut.WorkingDirectory = "$($env:HOMEDRIVE)\"
	$consoleShortcut.Save()
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null
}