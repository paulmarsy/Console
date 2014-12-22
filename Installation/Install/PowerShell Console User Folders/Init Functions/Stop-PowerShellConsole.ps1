function Stop-PowerShellConsole {
	if (Get-Module -Name CustomPowerShellConsole) {
		Remove-Module CustomPowerShellConsole -Force
	}
}