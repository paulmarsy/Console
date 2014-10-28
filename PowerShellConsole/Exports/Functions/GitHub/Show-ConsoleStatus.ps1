function Show-ConsoleStatus {
	[CmdletBinding()]
	param(
		[switch]$Detailed,
		[switch]$IncludeIgnored,
		[switch]$OnlyThisBranch
    )

	_workOnConsoleWorkingDirectory {
		_updateGitRemotes -Quiet

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
		Show-ConsoleUncomittedChanges -IncludeIgnored:$IncludeIgnored -Detailed:$Detailed
    }
}