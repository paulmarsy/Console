function Reload-PowerShellConsole {
	param(
		[switch]$Force
	)
	
	Stop-PowerShellConsole

	$Env:PowerShellConsoleStartUpPath = $PWD.Path
	
	Start-PowerShellConsole -Force:$Force
}