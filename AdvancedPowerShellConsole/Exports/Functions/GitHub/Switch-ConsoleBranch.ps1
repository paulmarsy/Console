function Switch-ConsoleBranch {
	[CmdletBinding()]
	param(
		$BranchName = "master"
    )

	_enterConsoleWorkingDirectory {
		param($BranchName)
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



    } $BranchName
}