function Switch-ConsoleBranch {
	[CmdletBinding(DefaultParameterSetName="ExistingBranch")]
	param(
		[Parameter(ParameterSetName="ExistingBranch", Position = 0)][ValidateSet("master")]$BranchName = "master",
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 0)][switch]$CreateNewBranch,
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 1)][ValidateSet("master")]$ParentBranchName,
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 2)]$NewBranchName
    )

	_workOnConsoleWorkingDirectory {
		param($BranchName, $CreateNewBranch, $ParentBranchName, $NewBranchName, $PsCmdlet)
	
		if ((Assert-ConsoleIsInSync -Quiet -AssertIsFatal) -eq $false) { return }

		if ($PsCmdlet.ParameterSetName -eq "NewBranch") {
			_invokeGitCommand "checkout $ParentBranchName"

			Write-Host -ForegroundColor Cyan "Creating remote branch $NewBranchName on GitHub..."
			_invokeGitCommand "push origin origin:refs/heads/$NewBranchName"
			_invokeGitCommand "remote --verbose update --prune" -Quiet
			
			Write-Host -ForegroundColor Cyan "Creating local branch $NewBranchName..."
			_invokeGitCommand "branch --set-upstream-to=origin/$NewBranchName $NewBranchName"

			Sync-ConsoleWithGitHub
			$BranchName = $NewBranchName
		}

		Write-Host -ForegroundColor Cyan "Switching to $(?: { $CreateNewBranch.IsPresent } { "new " })branch $BranchName..."
		_invokeGitCommand "checkout $BranchName"
    } @($BranchName, $CreateNewBranch, $ParentBranchName, $NewBranchName, $PsCmdlet)
}