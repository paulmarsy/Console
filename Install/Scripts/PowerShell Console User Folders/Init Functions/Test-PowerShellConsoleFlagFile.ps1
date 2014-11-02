function Test-PowerShellConsoleFlagFile {
	if (-not (Test-Path "##PowerShellConsoleEnabledFlagFile##") -and -not (Test-Path "##PowerShellConsoleDisabledFlagFile##")) {
		Write-Warning  "A PowerShell Console status flag file not found - creating enabled flag file as default"
		Enable-PowerShellConsole
	}
}