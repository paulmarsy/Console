function Update-ConsoleGit {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)]$commitMessage,
		[switch]$pushToGitHub
    )

    Push-Location $ProfileConfig.General.InstallPath
    try {
    	& git add -A
    	& git commit -a -m $commitMessage
    	if ($pushToGitHub) {
    		& git pull --rebase origin
    		& git push origin
    	}
    }
	finally {
		Pop-Location
	}
}
@{Function = "Update-ConsoleGit"}