function Save-ConsoleChanges {
	param(
		[Parameter(ValueFromRemainingArguments=$true)]$CommitMessage
    )

	_workOnConsoleWorkingDirectory {
		if ((_getNumberOfUncommitedChanges) -eq 0) {
			throw "There are no changes to commit to Git"
    	}

		while([string]::IsNullOrWhiteSpace($CommitMessage)) {
			Write-Host -ForegroundColor Red "ERROR: Commit message cannot be empty"
			$CommitMessage = Read-Host -Prompt "Commit message"
		}
    	
    	Write-Host -ForegroundColor Cyan "Commiting local Console Git changes..."

		_invokeGitCommand "add -A"
		_invokeGitCommand "commit -a -m ""$CommitMessage"""
	}
}