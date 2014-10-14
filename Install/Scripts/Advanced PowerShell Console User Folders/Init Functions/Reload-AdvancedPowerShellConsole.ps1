function Reload-AdvancedPowerShellConsole {
	param([switch]$Force)
	Stop-AdvancedPowerShellConsole -Force:$Force
	Start-AdvancedPowerShellConsole -Force:$Force
}