function Update-ConsoleGit {
	[CmdletBinding()]
	param(
		$commitMessage,
		[switch]$pushToGitHub
    )

    Push-Location $ProfileConfig.General.InstallPath
    try {
    	if (-not [string]::IsNullOrEmpty($commitMessage)) {
	    	Write-Host -ForegroundColor Cyan "Commiting change to local git..."
	    	& git add -A
	    	if ($LASTEXITCODE -ne 0) { Write-Host -ForegroundColor Red "Error!"; return; }
	    	& git commit -a -m $commitMessage
	    	if ($LASTEXITCODE -ne 0) { Write-Host -ForegroundColor Red "Error!"; return; }
		}
    	if ($pushToGitHub) {
    		Write-Host -ForegroundColor Cyan "Pulling changes from GitHub..."
    		& git pull --rebase origin
    		if ($LASTEXITCODE -ne 0) { Write-Host -ForegroundColor Red "Error!"; return; }
    		Write-Host -ForegroundColor Cyan "Pushing changes to GitHub..."
    		& git push origin
    		if ($LASTEXITCODE -ne 0) { Write-Host -ForegroundColor Red "Error!"; return; }
    	}
    	Write-Host -ForegroundColor Green "Done."
    }
	finally {
		Pop-Location
	}
}
@{Function = "Update-ConsoleGit"}