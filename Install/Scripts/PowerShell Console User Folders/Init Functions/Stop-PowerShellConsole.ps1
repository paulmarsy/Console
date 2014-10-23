function Stop-PowerShellConsole {
	if (Get-Module -Name PowerShellConsole) {
		Remove-Module PowerShellConsole -Force
	}
}