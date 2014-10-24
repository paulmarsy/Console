function Show-ConsoleStatus {
	[CmdletBinding()]
	param(
		[switch]$Detailed,
		[switch]$IncludeIgnored,
		[switch]$OnlyThisBranch
    )

	_workOnConsoleWorkingDirectory {
		_invokeGitCommand "remote --verbose update --prune" -Quiet

		$currentBranch = _getCurrentBranch

		Write-Host
		Write-Host -ForegroundColor Cyan "Currently on branch:"
		Write-Host -ForegroundColor Red "`t$currentBranch"

		if (-not $OnlyThisBranch) {
			if ($Detailed) {
				Write-Host
				Write-Host -ForegroundColor Cyan "Git Origin Configuration..."
				_invokeGitCommand "remote --verbose show origin"

				Write-Host
				Write-Host -ForegroundColor Cyan "Git Statistics..."
				_invokeGitCommand "count-objects --verbose --human-readable"
			} 

			Write-Host
			Write-Host -ForegroundColor Cyan "Remote tracking branches..."
			_invokeGitCommand "branch --remotes"

			Write-Host  
			Write-Host -ForegroundColor Cyan "Local branches..."
			_invokeGitCommand "branch --list"
		}

		Write-Host
		Write-Host -ForegroundColor Cyan "Branch structure..."
		$branchStructureCommand = "log --color --date-order --graph --oneline --decorate --no-walk"
		if (-not $OnlyThisBranch) {
			$branchStructureCommand += " --all"
		}
		if (-not $Detailed) {
			$branchStructureCommand += " --simplify-by-decoration"
		}
		_invokeGitCommand $branchStructureCommand

		Write-Host
		Write-Host -NoNewLine -ForegroundColor Cyan "Show uncommited changes ("
		$uncommitedChanges = _getNumberOfUncommitedChanges
		Write-Host -NoNewLine -ForegroundColor (?: { $uncommitedChanges -ge 1 } { "Red" } { "Green" }) $uncommitedChanges
		Write-Host -ForegroundColor Cyan ")..."
		_invokeGitCommand "status --short --branch --untracked-files=all $(?: { $IncludeIgnored } { "--ignored" })"
		Write-Host

		if ($Detailed) {
			Write-Host -ForegroundColor Cyan "Showing uncommited changes:"
			_invokeGitCommand "diff $currentBranch"
		}
    }
}