function Switch-ConsoleBranch {
	[CmdletBinding(DefaultParameterSetName="ExistingBranch")]
	param(
		[Parameter(ParameterSetName="ExistingBranch", Position = 0)][ValidateSet("master")]$BranchName = "master",
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 0)][switch]$CreateNewBranch,
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 1)][ValidateSet("master")]$ParentBranchName,
		[Parameter(ParameterSetName="NewBranch", Mandatory = $true, Position = 2)]$NewBranchName,
    )

	_enterConsoleWorkingDirectory {
		param($BranchName, $NewBranchName, $Force, $PsCmdlet)
	
		_checkBranchForUncommitedFiles

		if ($PsCmdlet.ParameterSetName -eq "NewBranch") {
			& git checkout $ParentBranchName | Write-Host

			Write-Host -ForegroundColor Cyan "Creating remote branch $NewBranchName on GitHub..."
			& git push origin origin:refs/heads/$NewBranchName | Write-Host
			_updateGitHubRemotes | Write-Host
			
			Write-Host -ForegroundColor Cyan "Creating local branch $NewBranchName..."
			& git branch --set-upstream-to=origin/$NewBranchName $NewBranchName | Write-Host

			Sync-ConsoleWithGitHub
			$BranchName = $NewBranchName
		}

		Write-Host -ForegroundColor Cyan "Switching to $(?: { $CreateNewBranch.IsPresent } { "new " })branch $BranchName..."
		& git checkout $BranchName
    } @($BranchName, $NewBranchName, $Force, $PsCmdlet) | Write-Host
}