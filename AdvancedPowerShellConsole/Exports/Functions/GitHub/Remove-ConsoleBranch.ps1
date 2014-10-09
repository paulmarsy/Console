function Remove-ConsoleBranch {
	param(
		[Parameter(Mandatory = $true)][ValidateSet("master")]$BranchName = "master",
		[switch]$Force
    )

    if ($BranchName -eq "master") {
    	Write-Host -ForegroundColor Red "ERROR: You can't delete the master branch!"
    	return
    }

	_workOnConsoleWorkingDirectory {
		param($BranchName)
	
		Write-Host -ForegroundColor Cyan "Removing branch $BranchName..."
		_invokeGitCommand "branch -D $BranchName"
		_invokeGitCommand "push origin --delete $BranchName"
		_invokeGitCommand "remote update --prune" -Quiet
		_updateGitHubCmdletParameters
    } @($BranchName)
}