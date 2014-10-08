function Save-ConsoleChanges {
	param(
		$CommitMessage
    )

	_workOnConsoleWorkingDirectory {
		param($CommitMessage)

		if ((_getNumberOfUncommitedChanges) -eq 0) {
			Write-Host -ForegroundColor Red "ERROR: There are no changes to commit to Git"
			return
    	}

		while([string]::IsNullOrWhiteSpace($CommitMessage)) {
			Write-Host -ForegroundColor Red "ERROR: Commit message cannot be empty"
			$CommitMessage = Read-Host -Prompt "Commit message"
		}
    	
    	Write-Host -ForegroundColor Cyan "Commiting local Console Git changes..."

		_invokeGitCommand "add -A"
		_invokeGitCommand "commit -a -m ""$CommitMessage"""
	} $CommitMessage
}