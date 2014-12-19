function Enable-PowerShellConsole {
	Set-Content -Path "##PowerShellConsoleEnabledFlagFile##" -Value $null
	if (Test-Path "##PowerShellConsoleDisabledFlagFile##") {
		Remove-Item "##PowerShellConsoleDisabledFlagFile##" -Force
	}
}