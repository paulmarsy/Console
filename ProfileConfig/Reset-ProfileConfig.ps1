function Reset-ProfileConfig {
	[CmdletBinding()]
	param(
		[switch]$Quiet
	)
	
	if (-not $Quiet) { Write-Host -ForegroundColor Cyan -NoNewLine "Resetting ProfileConfig... " }
	
	try {
		$module = $ExecutionContext.SessionState.Module

		Remove-Module $module
		Import-Module $module.Path -Global

		if (-not $Quiet) { Write-Host -ForegroundColor Green "Done." }
	}
	catch {
		Write-Host -ForegroundColor Red "`nError resetting ProfileConfig! $_"
	}
}