function Stop-AdvancedPowerShellConsole {
	param([switch]$Force)
	if (Get-Module -Name AdvancedPowerShellConsole) {
		Remove-Module AdvancedPowerShellConsole -Force:$Force
	}
}