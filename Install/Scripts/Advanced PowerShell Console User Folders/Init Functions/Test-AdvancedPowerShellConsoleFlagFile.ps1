function Test-AdvancedPowerShellConsoleFlagFile {
	if (-not (Test-Path "##AdvancedPowerShellConsoleEnabledFlagFile##") -and -not (Test-Path "##AdvancedPowerShellConsoleDisabledFlagFile##")) {
		Write-Warning  "AdvancedPowerShellConsoleFlagFile not found - creating enabled flag file as default"
		Enable-AdvancedPowerShellConsole
	}
}