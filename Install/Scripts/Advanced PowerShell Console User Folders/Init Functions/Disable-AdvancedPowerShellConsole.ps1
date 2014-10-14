function Disable-AdvancedPowerShellConsole {
	Set-Content -Path "##AdvancedPowerShellConsoleDisabledFlagFile##" -Value $null
	if (Test-Path "##AdvancedPowerShellConsoleEnabledFlagFile##") {
		Remove-Item "##AdvancedPowerShellConsoleEnabledFlagFile##" -Force
	}
}