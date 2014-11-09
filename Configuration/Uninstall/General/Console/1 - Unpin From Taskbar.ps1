Invoke-InstallStep "Unpinning Console from Taskbar" {
	$taskbarPinner = Join-Path $PowerShellConsoleContstants.InstallPath "Libraries\Binaries\TaskbarPinner.exe"
	$consoleShortcut = Join-Path ([Environment]::GetFolderPath("StartMenu")) "Console.lnk"
	if (Test-Path $consoleShortcut) {
		& $taskbarPinner remove taskbar $consoleShortcut
	}
}