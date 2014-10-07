function Sync-ProfileConfig {
	[CmdletBinding()]
	param(
		[switch]$Quiet
	)
	if (-not $Quiet) { Write-Host -ForegroundColor Cyan -NoNewLine "Synchronizing ProfileConfig... " }
	
	try {
		$module = $ExecutionContext.SessionState.Module
		$installPath = $ProfileConfig.General.InstallPath

		Remove-Module $module -ErrorAction SilentlyContinue
		Import-Module $module.Path -ArgumentList $installPath -Global

		if (-not $Quiet) { Write-Host -ForegroundColor Green "Done." }
	}
	catch {
		Write-Host -ForegroundColor Red "Error$(?: { $Quiet } { " synchronizing ProfileConfig" } -NullCheck)! $_"
	}
}