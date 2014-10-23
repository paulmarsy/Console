function Test-PowerShellConsoleFlagFile {
	if (-not (Test-Path "##PowerShellConsoleEnabledFlagFile##") -and -not (Test-Path "##PowerShellConsoleDisabledFlagFile##")) {
		Write-Warning  "PowerShellConsoleFlagFile not found - creating enabled flag file as default"
		Enable-PowerShellConsole
	}
}