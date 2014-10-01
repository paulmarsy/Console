function Switch-ConsoleBranch {
	[CmdletBinding()]
	param(
		$BranchName
    )

    Push-Location $ProfileConfig.General.InstallPath
    try {
		$uncommitedChanges = & git status --porcelain 2>$null | Measure-Object -Line | Select-Object -ExpandProperty Lines
		if ($uncommitedChanges -gt 0) {
			$autoCheckin = Show-ConfirmationPrompt -Caption "You have uncommited changes in the current branch" -Message "Do you want to check them in now?"
			if ($autoCheckin) {
				$commitMessage = Read-Host -Prompt "Commit message"
				Sync-Console -CommitMessage $commitMessage -DontSyncWithGitHub
			}
		}
    }
	finally {
		Pop-Location
	}
}