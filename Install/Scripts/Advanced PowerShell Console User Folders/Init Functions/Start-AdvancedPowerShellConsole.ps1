function Start-AdvancedPowerShellConsole {
	param([switch]$Force)

	if ((Test-Path "##AdvancedPowerShellConsoleDisabledFlagFile##") -and -not $Force) {
	    Write-Host -ForegroundColor Red "Not starting AdvancedPowerShellConsole, disabled flag is set. Either enable the flag file or use the -Force switch"
	} elseif ((Test-Path "##AdvancedPowerShellConsoleEnabledFlagFile##") -or $Force) {
		Import-Module "##AdvancedPowerShellConsoleModulePath##" -ArgumentList "##InstallPath##" -Force -Global
	}
}