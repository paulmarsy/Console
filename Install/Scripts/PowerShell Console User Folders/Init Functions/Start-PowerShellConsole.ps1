function Start-PowerShellConsole {
	param([switch]$Force)

	if ((Test-Path "##PowerShellConsoleDisabledFlagFile##") -and -not $Force) {
	    Write-Host -ForegroundColor Red "Not starting PowerShellConsole, disabled flag is set. Either enable the flag file or use the -Force switch"
	} elseif ((Test-Path "##PowerShellConsoleEnabledFlagFile##") -or $Force) {
		Import-Module "##PowerShellConsoleModulePath##" -ArgumentList "##InstallPath##" -Force -Global
	}
}