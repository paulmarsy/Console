function Disable-PowerShellConsole {
	Set-Content -Path "##PowerShellConsoleDisabledFlagFile##" -Value $null
	if (Test-Path "##PowerShellConsoleEnabledFlagFile##") {
		Remove-Item "##PowerShellConsoleEnabledFlagFile##" -Force
	}
}