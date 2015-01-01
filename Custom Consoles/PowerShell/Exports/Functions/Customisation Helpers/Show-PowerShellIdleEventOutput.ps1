function Show-PowerShellIdleEventOutput {
	$idleAction = Get-EventSubscriber -Force -SourceIdentifier CustomPowerShellConsoleIdleTimer | %  Action
	Write-Host -ForegroundColor Cyan "Output Stream:"
	$idleAction.Output.ReadAll()
	Write-Host -ForegroundColor Cyan "Error Stream:"
	$idleAction.Error.ReadAll()
}