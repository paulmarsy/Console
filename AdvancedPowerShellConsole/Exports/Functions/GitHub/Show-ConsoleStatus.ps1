function Show-ConsoleStatus {
	[CmdletBinding()]
	param(
		[switch]$IncludeIgnored
    )

	_workOnConsoleWorkingDirectory {
		param($IncludeIgnored)
		_invokeGitCommand "remote --verbose update --prune" -Quiet

		Write-Host -ForegroundColor Cyan "Currently on branch:"
		Write-Host -ForegroundColor Red "`t$(_getCurrentBranch)"

		Write-Host -ForegroundColor Cyan "`nRemote tracking branches..."
		_invokeGitCommand "branch --remotes"

		Write-Host -ForegroundColor Cyan "`nLocal branches..."
		_invokeGitCommand "branch --list"

		Write-Host -ForegroundColor Cyan "`nBranch structure..."

		Write-Host -ForegroundColor Cyan "`nShow uncommited changes..."
		_invokeGitCommand "status --short --branch --untracked-files=all $(?: { $IncludeIgnored } { "--ignored" })"
    } $IncludeIgnored
}