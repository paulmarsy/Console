function Assert-ConsoleIsInSync {
	param(
		[switch]$Quiet
	)
	
    _workOnConsoleWorkingDirectory {
		$uncommitedChanges = _getNumberOfUncommitedChanges

        if (-not $Quiet) {
            Write-Host -NoNewLine "The workspace for branch "
            Write-Host -NoNewLine -ForegroundColor Yellow (_getCurrentBranch)
            Write-Host -NoNewLine " has "  
            Write-Host -NoNewLine -ForegroundColor (?: { $uncommitedChanges -eq 0 } { "Green" } { "Red" }) "#$uncommitedChanges"
            Write-Host " uncommited changes"
        }

        if ($uncommitedChanges -eq 0) { return $true }
        else { return $false }
        
    } -ReturnValue
}