function Show-PowerShellIdleEventOutput {
	Get-EventSubscriber -Force -SourceIdentifier CustomPowerShellConsoleIdleTimer | %  Action | % Output
}