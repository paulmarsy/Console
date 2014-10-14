Invoke-InstallStep "Pinning Console to Taskbar" {
	$taskbarPinner = Join-Path $InstallPath "Support Files\TaskbarPinner.exe"
	$consoleShortcut = Join-Path ([Environment]::GetFolderPath("StartMenu")) "Console.lnk"
	& $taskbarPinner add taskbar $consoleShortcut
}

Invoke-InstallStep "Setting up Console Jump List Tasks" {
	& $ConEmuExecutablePath /UpdateJumpList /Exit
}