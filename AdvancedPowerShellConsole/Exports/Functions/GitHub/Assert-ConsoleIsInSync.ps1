function Assert-ConsoleIsInSync {
	param(
		[switch]$Quiet,
		[switch]$AssertIsFatal
	)
	_workOnConsoleWorkingDirectory {
		param($Quiet, $AssertIsFatal)

		$uncommitedChanges = _getNumberOfUncommitedChanges
    	if ($uncommitedChanges -eq 0) {
    		if (-not $Quiet) { Write-Host -ForegroundColor Green "Branch $(_getCurrentBranch) has no uncommited changes" }
    		return $true
    	} else {
    		if (-not $Quiet -or $AssertIsFatal) { Write-Host -ForegroundColor Red "Branch $(_getCurrentBranch) has #$uncommitedChanges uncommited changes" }
    		if ($AssertIsFatal) { Write-Host -ForegroundColor Red "Unable to continue, use Save-ConsoleChanges to commit the changes and retry"}
    		return $false
    	}
    } @($Quiet, $AssertIsFatal)
}