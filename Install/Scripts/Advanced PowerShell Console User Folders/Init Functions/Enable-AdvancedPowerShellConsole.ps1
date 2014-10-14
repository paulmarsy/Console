function Enable-AdvancedPowerShellConsole {
	Set-Content -Path "##AdvancedPowerShellConsoleEnabledFlagFile##" -Value $null
	if (Test-Path "##AdvancedPowerShellConsoleDisabledFlagFile##") {
		Remove-Item "##AdvancedPowerShellConsoleDisabledFlagFile##" -Force
	}
}