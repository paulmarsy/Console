function Resolve-ConsoleRebaseIssue {
	param(
		[Parameter(Position = 0)][ValidateSet("Continue", "Skip", "Abort")]$Resolution = "Continue",
		[Parameter(Position = 1, ValueFromRemainingArguments=$true)]$CommitMessage
    )

	_workOnConsoleWorkingDirectory {
		if ($Resolution -eq "Continue") {
			Save-ConsoleChanges -CommitMessage:$CommitMessage
		}

		switch ($Resolution) {
			"Continue" { $rebaseSwitch = "--continue" }
			"Skip" { $rebaseSwitch = "--continue" }
			"Abort" { $rebaseSwitch = "--continue" }
		}

    	Write-Host -ForegroundColor Cyan "Continuing with Git rebase using '$Resolution' choice..."
		_invokeGitCommand "rebase $rebaseSwitch"
	}
}