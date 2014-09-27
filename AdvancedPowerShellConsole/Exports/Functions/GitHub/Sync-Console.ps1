function Sync-Console {
	[CmdletBinding(DefaultParameterSetName = "Commit")]
	param(
		[Parameter(ParameterSetName = "Commit", Position = 1)]$CommitMessage,
		[Parameter(ParameterSetName = "Commit")][switch]$DontSyncWithGitHub,
		[Parameter(ParameterSetName = "Discard")][switch]$DiscardChanges
    )

    Push-Location $ProfileConfig.General.InstallPath
    try {
    	if ($DiscardChanges) {
			& git clean -df
			& git checkout .
    	} else {
    		if (-not [string]::IsNullOrWhiteSpace($CommitMessage)) {
		    	Write-Host -ForegroundColor Cyan "Commiting change to local git..."
		    	& git add -A
		    	& git commit -a -m $commitMessage
	    	}

	    	if (-not $DontSyncWithGitHub) {
	    		Write-Host -ForegroundColor Cyan "Pulling changes from GitHub..."
	    		& git pull --rebase origin
	    		if ($LASTEXITCODE -ne 0) { Write-Host -ForegroundColor Red "Error!"; return; }
	    		Write-Host -ForegroundColor Cyan "Pushing changes to GitHub..."
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