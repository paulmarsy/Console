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
		if (_getNumberOfUncommitedChanges -gt 0) {
			$autoCheckin = Show-ConfirmationPrompt -Caption "You have uncommited changes in the current branch" -Message "Do you want to check them in now?"
			if ($autoCheckin) {
				$commitMessage = Read-Host -Prompt "Commit message"
				Sync-Console -CommitMessage $commitMessage -DontSyncWithGitHub
			} else {
				Write-Host -ForegroundColor Red "ERROR: Cannot switch branch while there are uncommited changes"
				return
			}
		}
		if (_getNumberOfUncommitedChanges -gt 0) {
			Write-Host -ForegroundColor Red "ERROR: There are still uncommited changes in the workspace, unable to switch branch this has been manually resolved"
			return
		}

		if ($PsCmdlet.ParameterSetName -eq "NewBranch") {
			 & git branch $NewBranchName (?: { $Force.IsPresent } { "--force" })
			 & git push origin $NewBranchName

			 _updateGitHub

			 $BranchName = $NewBranchName
		}

		& git checkout $BranchName


    } $@($BranchName, $CreateNew, $Force, $PsCmdlet)
}