Invoke-InstallStep "Unpinning Console from Taskbar" {
	$taskbarPinner = Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Custom Helper Apps\TaskbarPinner\TaskbarPinner.exe"
	$consoleShortcut = Join-Path ([Environment]::GetFolderPath("StartMenu")) "Console.lnk"
	if (Test-Path $consoleShortcut) {
		& $taskbarPinner remove taskbar $consoleShortcut
	}
}