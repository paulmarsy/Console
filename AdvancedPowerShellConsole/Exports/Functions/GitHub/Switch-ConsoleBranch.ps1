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
			 & git branch $NewBranchName (?: { $Force.IsPresent } { "--force" })
			 & git push origin $NewBranchName

			 Sync-Console

			 $BranchName = $NewBranchName
		}

		Write-Host -ForegroundColor Cyan "Switching to new branch..."
		& git checkout $BranchName


    } $@($BranchName, $CreateNew, $Force, $PsCmdlet)
}