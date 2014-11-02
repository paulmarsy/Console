function Reload-PowerShellConsole {
	param(
		[switch]$Force
	)
	
	Stop-PowerShellConsole
	Start-PowerShellConsole -Force:$Force
}