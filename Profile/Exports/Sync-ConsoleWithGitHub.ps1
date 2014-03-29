function Sync-ConsoleWithGitHub {
	[CmdletBinding(DefaultParameterSetName = "Commit")]
	param(
		[Parameter(ParameterSetName = "Commit", Position = 1)]$commitMessage,
		[Parameter(ParameterSetName = "Commit")][switch]$dontSyncWithGitHub,
		[Parameter(ParameterSetName = "Status")][switch]$status
    )

    Push-Location $ProfileConfig.General.InstallPath
    try {
    	if ($status) {
    		& git status
    	}
    	else {
    		if (-not [string]::IsNullOrWhiteSpace($commitMessage)) {
		    	Write-Host -ForegroundColor Cyan "Commiting change to local git..."
		    	& git add -A
		    	& git commit -a -m $commitMessage
	    	}

	    	if (-not $dontSyncWithGitHub) {
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
@{Function = "Sync-ConsoleWithGitHub"}