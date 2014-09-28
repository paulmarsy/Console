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
			& git clean -df @argumentsQuiet
			& git checkout . @argumentsQuiet
    	} else {
    		if (-not [string]::IsNullOrWhiteSpace($CommitMessage)) {
		    	if (-not $Quiet) { Write-Host -ForegroundColor Cyan "Commiting change to local git..." }
		    	& git add -A @argumentsVerbose
		    	& git commit -a -m $commitMessage @argumentsBoth
	    	}

	    	if (-not $DontSyncWithGitHub) {
	    		if (-not $Quiet) { Write-Host -ForegroundColor Cyan "Pulling changes from GitHub..." }
	    		& git remote update @argumentsVerbose

	    		$local = & git rev-parse `@
	    		$remote = & git rev-parse `@`{u`}
	    		$base = & git merge-base `@ `@`{u`}

	    		if ($local -eq $remote) {
	    			if (-not $Quiet) { Write-Host -ForegroundColor Green "Local Console is in sync with Github." }
	    		} else {
	    			$pullNeeded = $local -eq $base
	    			$pushNeeded = $remote -eq $base
	    			if (-not $pullNeeded -and -not $pushNeeded) {
	    				$pullNeeded = $true
	    				$pushNeeded = $true
	    			}

	    			if ($pullNeeded) {
	    				if (-not $Quiet) { Write-Host -ForegroundColor Cyan "Pulling changes from GitHub..." }
	    				& git pull --rebase origin @argumentsBoth
	    				if ($LASTEXITCODE -ne 0) { Write-Host -ForegroundColor Red "Error pulling changes from GitHub!"; return; }
	    			}
	    			if ($pushNeeded) {
	    				if (-not $Quiet) { Write-Host -ForegroundColor Cyan "Pushing changes to GitHub..." }
	    				& git push origin @argumentsBoth
	    				if ($LASTEXITCODE -ne 0) { Write-Host -ForegroundColor Red "Error pushing changed to GitHub!"; return; }
	    			}
	    		}
	    	}
	    	if (-not $Quiet) { Write-Host -ForegroundColor Green "Done." }
	    }
    }
	finally {
		Pop-Location
	}
}