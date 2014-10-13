function Show-ConsoleStatus {
	[CmdletBinding()]
	param(
		[switch]$Detailed,
		[switch]$IncludeIgnored,
		[switch]$OnlyThisBranch
    )

	_workOnConsoleWorkingDirectory {
		_invokeGitCommand "remote --verbose update --prune" -Quiet

		Write-Host -ForegroundColor Cyan "Currently on branch:"
		Write-Host -ForegroundColor Red "`t$(_getCurrentBranch)"

		if (-not $OnlyThisBranch) {
			if ($Detailed) {
				Write-Host -ForegroundColor Cyan "`nGit Origin Configuration..."
				_invokeGitCommand "remote --verbose show origin"
			} 

			Write-Host -ForegroundColor Cyan "`nRemote tracking branches..."
			_invokeGitCommand "branch --remotes"

			Write-Host -ForegroundColor Cyan "`nLocal branches..."
			_invokeGitCommand "branch --list"
		}

		Write-Host -ForegroundColor Cyan "`nBranch structure..."
		$branchStructureCommand = "log --color --date-order --graph --oneline --decorate --no-walk"
		if (-not $OnlyThisBranch) {
			$branchStructureCommand += " --all"
		}
		if (-not $Detailed) {
			$branchStructureCommand += " --simplify-by-decoration"
		}
		_invokeGitCommand $branchStructureCommand

		Write-Host -ForegroundColor Cyan "`nShow uncommited changes..."
		_invokeGitCommand "status --short --branch --untracked-files=all $(?: { $IncludeIgnored } { "--ignored" })"
    }
}