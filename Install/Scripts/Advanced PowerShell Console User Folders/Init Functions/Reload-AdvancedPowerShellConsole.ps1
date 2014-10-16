function Reload-AdvancedPowerShellConsole {
	param([switch]$Force)
	Stop-AdvancedPowerShellConsole
	Start-AdvancedPowerShellConsole -Force:$Force
}