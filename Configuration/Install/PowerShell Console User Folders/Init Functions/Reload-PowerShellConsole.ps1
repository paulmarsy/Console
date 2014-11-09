function Reload-PowerShellConsole {
	param(
		[switch]$Force
	)
	
	Stop-PowerShellConsole

	[System.Environment]::SetEnvironmentVariable("PowerShellConsoleStartUpPath", $PWD.Path, [System.EnvironmentVariableTarget]::Process)

	Start-PowerShellConsole -Force:$Force
}