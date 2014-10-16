function Stop-AdvancedPowerShellConsole {
	if (Get-Module -Name AdvancedPowerShellConsole) {
		Remove-Module AdvancedPowerShellConsole -Force
	}
}