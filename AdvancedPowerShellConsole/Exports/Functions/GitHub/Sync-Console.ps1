function Sync-Console {
	[CmdletBinding(DefaultParameterSetName = "Commit")]
	param(
		[Parameter(ParameterSetName = "Commit", Position = 1)]$CommitMessage,
		[Parameter(ParameterSetName = "Commit")][switch]$DontSyncWithGitHub,
		[Parameter(ParameterSetName = "Discard")][switch]$DiscardChanges,
		[switch]$Quiet
    )

    Push-Location $ProfileConfig.General.InstallPath
    try {
    	$argumentsVerbose = @()
    	$argumentsQuiet = @()

    	if ($PSBoundParameters['Verbose']) { $argumentsVerbose += @("--verbose") }
    	if ($Quiet) { $argumentsQuiet += @("--quiet") }
    	$argumentsBoth = $argumentsVerbose + $argumentsQuiet

    	if ($DiscardChanges) {
			& git clean -df
			& git checkout .
    	} else {
    		if (-not [string]::IsNullOrWhiteSpace($CommitMessage)) {
		    	if (-not $Quiet) { Write-Host -ForegroundColor Cyan "Commiting change to local git..." }
		    	& git add -A
		    	& git commit -a -m $commitMessage
	    	}

	    	if (-not $DontSyncWithGitHub) {
	    		if (-not $Quiet) { Write-Host -ForegroundColor Cyan "Pulling changes from GitHub..." }
	    		& git remote update

	    		$local = & git rev-parse `@
	    		$remote = & git rev-parse `@`{u`}
	    		$base = & git merge-base `@ `@`{u`}

	    		if (-not $Quiet) { Write-Host -ForegroundColor Cyan "Pulling changes from GitHub..." }
	    		& git pull --rebase origin
	    		if ($LASTEXITCODE -ne 0) { Write-Host -ForegroundColor Red "Error!"; return; }
	    		if (-not $Quiet) { Write-Host -ForegroundColor Cyan "Pushing changes to GitHub..." }
	    		& git push origin
	    		if ($LASTEXITCODE -ne 0) { Write-Host -ForegroundColor Red "Error!"; return; }
	    	}
	    	Write-Host -ForegroundColor Green "Done."
	    }
    }
	finally {
		Pop-Location
	}
}