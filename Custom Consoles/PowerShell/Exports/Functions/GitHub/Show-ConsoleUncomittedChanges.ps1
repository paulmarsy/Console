function Show-ConsoleUncomittedChanges {
	param(
		[switch]$IncludeIgnored,
		[switch]$Detailed
    )

	_workOnConsoleWorkingDirectory {
		Write-Host -NoNewLine -ForegroundColor Cyan "Show uncommited changes ("
		$uncommitedChanges = _getNumberOfUncommitedChanges
		Write-Host -NoNewLine -ForegroundColor (?: { $uncommitedChanges -ge 1 } { "Red" } { "Green" }) $uncommitedChanges
		Write-Host -ForegroundColor Cyan ")..."
		_invokeGitCommand "status --short --branch --untracked-files=all $(?: { $IncludeIgnored } { "--ignored" })"

		if ($Detailed) {
			Write-Host
			Write-Host -ForegroundColor Cyan "Showing uncommited changes:"
			_invokeGitCommand "diff $(_getCurrentBranch)"
		}
    }
}