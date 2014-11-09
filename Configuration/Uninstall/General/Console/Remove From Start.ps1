$consoleShortcut = Join-Path ([Environment]::GetFolderPath("StartMenu")) "Console.lnk"

Invoke-InstallStep "Removing Console Start Shortcut" {
	if (Test-Path $consoleShortcut) {
		Remove-Item -Path $consoleShortcut -Force
	}
}