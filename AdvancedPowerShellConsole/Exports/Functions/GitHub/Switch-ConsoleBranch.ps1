function Switch-ConsoleBranch {
	[CmdletBinding(DefaultParameterSetName="ExistingBranch")]
	param(
		[Parameter(ParameterSetName="ExistingBranch")][ValidateSet("master")]$BranchName = "master",
		[Parameter(ParameterSetName="NewBranch")]$NewBranchName,
		[Parameter(ParameterSetName="NewBranch")]$CreateNew,
		[Parameter(ParameterSetName="NewBranch")]$Force
    )

	_enterConsoleWorkingDirectory {
		param($BranchName, $CreateNew, $Force, $PsCmdlet)
	
		_checkBranchForUncommitedFiles

		if ($PsCmdlet.ParameterSetName -eq "NewBranch") {
			Write-Host -ForegroundColor Cyan "Creating branch $NewBranchName..."
			& git branch $NewBranchName (?: { $Force.IsPresent } { "--force" })
			
			Write-Host -ForegroundColor Cyan "Publishing branch to GitHub..."
			& git push -u origin $NewBranchName
			Sync-Console

			$BranchName = $NewBranchName
		}

		Write-Host -ForegroundColor Cyan "Switching to new branch..."
		& git checkout $BranchName
    } $@($BranchName, $CreateNew, $Force, $PsCmdlet)
}