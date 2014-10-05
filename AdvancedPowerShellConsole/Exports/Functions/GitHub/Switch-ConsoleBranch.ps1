function Switch-ConsoleBranch {
	[CmdletBinding(DefaultParameterSetName="ExistingBranch")]
	param(
		[Parameter(ParameterSetName="ExistingBranch", Position = 0)][ValidateSet("master")]$BranchName = "master",
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 0)][ValidateSet("master")]$ParentBranchName,
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 1)]$ChildBranchName,
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true)][switch]$CreateNewBranch
    )

	_enterConsoleWorkingDirectory {
		param($BranchName, $NewBranchName, $Force, $PsCmdlet)
	
		_checkBranchForUncommitedFiles

		& git checkout $BranchName

		if ($PsCmdlet.ParameterSetName -eq "NewBranch") {
			Write-Host -ForegroundColor Cyan "Creating new branch $NewBranchName..."
			& git push origin origin:refs/heads/$NewBranchName
			_updateGitHubRemotes
			



			& git branch --track $NewBranchName (?: { $Force.IsPresent } { "--force" })
			
			Write-Host -ForegroundColor Cyan "Publishing branch to GitHub..."
			& git push -u origin $NewBranchName

			$BranchName = $NewBranchName
		}

		Write-Host -ForegroundColor Cyan "Switching to $(?: { $CreateNewBranch.IsPresent } { "new " })branch $BranchName..."
		& git checkout $BranchName
    } @($BranchName, $NewBranchName, $Force, $PsCmdlet) | Write-Host
}