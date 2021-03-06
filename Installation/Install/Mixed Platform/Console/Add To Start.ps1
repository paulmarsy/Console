$consoleShortcut = Join-Path ([Environment]::GetFolderPath("StartMenu")) "Console.lnk"

Invoke-InstallStep "Setting up Console Start Shortcut" {
	$WshShell = New-Object -ComObject WScript.Shell
	$consoleShortcut = $WshShell.CreateShortcut($consoleShortcut)
	$consoleShortcut.TargetPath = $PowerShellConsoleConstants.Executables.ConEmu
	$consoleShortcut.IconLocation = $conEmuPowerShellIcon
	$consoleShortcut.WorkingDirectory = "$($env:HOMEDRIVE)\"
	$consoleShortcut.Save()
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null
}