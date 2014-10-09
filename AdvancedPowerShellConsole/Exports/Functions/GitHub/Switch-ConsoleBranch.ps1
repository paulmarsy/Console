function Switch-ConsoleBranch {
	[CmdletBinding(DefaultParameterSetName="ExistingBranch")]
	param(
		[Parameter(ParameterSetName="ExistingBranch", Position = 0)][ValidateSet("master")]$BranchName = "master",
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 0)][switch]$CreateNewBranch,
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 1)]$NewBranchName,
		[Parameter(ParameterSetName="NewBranch", Position = 2)][ValidateSet("master")]$ParentBranchName = "master",
		$ScriptBlock
    )

	_workOnConsoleWorkingDirectory {
		param($BranchName, $CreateNewBranch, $ParentBranchName, $NewBranchName)
	
		$currentBranch = _getCurrentBranch

		if ($CreateNewBranch) {
			_invokeGitCommand "checkout $ParentBranchName"

			Write-Host -ForegroundColor Cyan "Creating remote branch $NewBranchName on GitHub..."
			_invokeGitCommand "push origin origin:refs/heads/$NewBranchName"
			_invokeGitCommand "remote --verbose update --prune" -Quiet
			
			Write-Host -ForegroundColor Cyan "Creating local branch $NewBranchName..."
			_invokeGitCommand "branch $NewBranchName origin/$NewBranchName"

			Sync-ConsoleWithGitHub
			$BranchName = $NewBranchName
		}

		Write-Host -ForegroundColor Cyan "Switching to $(?: { $CreateNewBranch } { "new " } -NotNullCheck)branch $BranchName..."
		_invokeGitCommand "checkout $BranchName"

		if ($ScriptBlock) {
			$ScriptBlock.Invoke()
			if ($currentBranch -ne $BranchName) {
				_invokeGitCommand "checkout $currentBranch"
			}
		}
    } @($BranchName, $CreateNewBranch, $ParentBranchName, $NewBranchName)
}