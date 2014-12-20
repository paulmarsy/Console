Invoke-InstallStep "Pinning Console to Taskbar" {
	$taskbarPinner = Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Custom Helper Apps\TaskbarPinner\TaskbarPinner.exe"
	$consoleShortcut = Join-Path ([Environment]::GetFolderPath("StartMenu")) "Console.lnk"
	& $taskbarPinner add taskbar $consoleShortcut
}

Invoke-InstallStep "Setting up Console Jump List Tasks" {
	& $PowerShellConsoleConstants.Executables.ConEmu /UpdateJumpList /Exit
}