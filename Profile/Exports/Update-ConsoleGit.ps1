function Update-ConsoleGit {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)]$commitMessage,
		[switch]$pushToGitHub
    )

    Push-Location $ProfileConfig.General.InstallPath
    try {
    	Write-Host -ForegroundColor Cyan "Commiting change to local git..."
    	& git add -A
    	& git commit -a -m $commitMessage
    	if ($pushToGitHub) {
    		Write-Host -ForegroundColor Cyan "Pulling changes from GitHub..."
    		& git pull --rebase origin
    		Write-Host -ForegroundColor Cyan "Pushing changes to GitHub..."
    		& git push origin
    	}
    	Write-Host -ForegroundColor Green "Done."
    }
	finally {
		Pop-Location
	}
}
@{Function = "Update-ConsoleGit"}