function Save-LocalConsoleChanges {
	param(
		[Parameter(ValueFromRemainingArguments=$true)]$CommitMessage
    )

	while([string]::IsNullOrWhiteSpace($CommitMessage)) {
		Write-Host -ForegroundColor Red "ERROR: Commit message cannot be empty"
		$CommitMessage = Read-Host -Prompt "Commit message"
	}

	$script:changesCommited = $false

	function commitChanges {
		param($Repo)
		if ((_getNumberOfUncommitedChanges) -eq 0) { return }

		Write-Host -ForegroundColor Cyan "Commiting changes to $Repo"
		_invokeGitCommand "add -A" | Out-Null
		_invokeGitCommand "commit -a -m `"$CommitMessage`""
		$script:changesCommited = $true
	}

	_workOnConsoleWorkingDirectory {
		_getSubmodulePaths | % {
			try {
				Push-Location $_
				commitChanges $_
			}
			finally {
				Pop-Location
			}
		}

		commitChanges "Main Repo"

		if ($script:changesCommited) {
    		Write-Host -ForegroundColor Green "Changes commited successfully!"
		} else {
			Write-Host -ForegroundColor Red "No changes commited"
		}
    }
}