function Remove-ConsoleBranch {
	param(
		[Parameter(Mandatory = $true)][ValidateSet("master")]$BranchName = "master",
		[switch]$Force
    )

    if (-not (Test-NetworkStatus)) {
		Write-Host -ForegroundColor Red "ERROR: Unable to continue without network connectivity"
		return
    }

    if (-not $Force) {
		Write-Host -ForegroundColor Red "ERROR: To delete a branch you must specify the -Force flag for confirmartion"
		return
    }

    if ($BranchName -eq "master") {
    	Write-Host -ForegroundColor Red "ERROR: You can't delete the master branch!"
    	return
    }

	_workOnConsoleWorkingDirectory {
		if ($BranchName -eq (_getCurrentBranch)) {
			Write-Host -ForegroundColor Yellow "Can't remove branch $BranchName as currently checked out, switching to the master branch..."
			Switch-ConsoleBranch -BranchName master
		}
	
		Write-Host -ForegroundColor Cyan "Removing branch $BranchName..."
		_invokeGitCommand "branch -D $BranchName"
		_invokeGitCommand "push origin --delete $BranchName"
		_updateGitRemotes -Quiet
		_updateGitHubCmdletParameters
    }
}