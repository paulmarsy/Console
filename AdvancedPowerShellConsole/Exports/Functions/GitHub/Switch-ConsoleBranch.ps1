function Switch-ConsoleBranch {
	[CmdletBinding(DefaultParameterSetName="ExistingBranch")]
	param(
		[Parameter(ParameterSetName="ExistingBranch", Position = 0)][ValidateSet("master")]$BranchName = "master",
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 0)][switch]$CreateNewBranch,
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 1)]$NewBranchName,
		[Parameter(ParameterSetName="NewBranch", Position = 2)][ValidateSet("master")]$ParentBranchName = "master",
		[switch]$Quiet
    )

	if ($CreateNewBranch -and -not (Test-NetworkStatus)) {
		Write-Host -ForegroundColor Red "ERROR: Unable to continue without network connectivity"
		return
    }

	_workOnConsoleWorkingDirectory {
		if ($CreateNewBranch) {
			_invokeGitCommand "checkout $ParentBranchName"

			Write-Host -ForegroundColor Cyan "Creating remote branch $NewBranchName on GitHub..."
			_invokeGitCommand "push origin origin:refs/heads/$NewBranchName"
			_invokeGitCommand "fetch origin $NewBranchName"
			
			Write-Host -ForegroundColor Cyan "Creating local branch $NewBranchName..."
			_invokeGitCommand "branch $NewBranchName origin/$NewBranchName"
			
			$BranchName = $NewBranchName
		}

		if (-not $Quiet) { Write-Host -ForegroundColor Cyan "Switching to $(?: { $CreateNewBranch.IsPresent } { "new " })branch $BranchName..." }
		_invokeGitCommand "checkout $BranchName" -Quiet:$Quiet
    }
}