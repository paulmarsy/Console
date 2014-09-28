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

    	if ($PsCmdlet.ParameterSetName -eq "Discard") {
			& git clean -df @argumentsQuiet
			& git checkout . @argumentsQuiet
    	} 
    	if ($PsCmdlet.ParameterSetName -eq "Commit") {
    		if (-not [string]::IsNullOrWhiteSpace($CommitMessage)) {
		    	if (-not $Quiet) { Write-Host -ForegroundColor Cyan "Commiting change to local git..." }
		    	& git add -A @argumentsVerbose | ? { -not $Quiet } | Write-Host
		    	& git commit -a -m $commitMessage @argumentsBoth
	    	}

	    	if (-not $DontSyncWithGitHub) {
	    		if (-not $Quiet) { Write-Host -NoNewLine -ForegroundColor Cyan "Synchronizing with GitHub..." }
	    		& git remote @argumentsVerbose update | Out-Null

	    		$local = & git rev-parse `@
	    		$remote = & git rev-parse `@`{u`}
	    		$base = & git merge-base `@ `@`{u`}

	    		if (-not $Quiet) { Write-Host -ForegroundColor Green " Done." }

	    		if ($local -eq $remote) {
	    			if (-not $Quiet) { Write-Host -ForegroundColor Green "Local Git Repo is in sync with Github." }
	    		} else {
	    			if ($remote -ne $base) {
	    				if (-not $Quiet) { Write-Host -NoNewLine -ForegroundColor Cyan "Pulling changes from GitHub..." }
	    				& git pull --rebase origin @argumentsBoth
	    				if ($LASTEXITCODE -ne 0) { Write-Host -ForegroundColor Red " Error pulling changes from GitHub!"; return; }
						elseif (-not $Quiet) { Write-Host -ForegroundColor Green " Done." }
	    			}
	    			if ($local -ne $base) {
	    				if (-not $Quiet) { Write-Host -NoNewLine -ForegroundColor Cyan "Pushing changes to GitHub..." }
	    				& git push origin @argumentsBoth
	    				if ($LASTEXITCODE -ne 0) { Write-Host -ForegroundColor Red " Error pushing changed to GitHub!"; return; }
	    				elseif (-not $Quiet) { Write-Host -ForegroundColor Green " Done." }
	    			}
	    		}
	    	}
	    }
    }
	finally {
		Pop-Location
	}
}