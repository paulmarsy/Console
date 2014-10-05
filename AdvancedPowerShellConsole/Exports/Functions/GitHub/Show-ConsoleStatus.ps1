function Show-ConsoleStatus {
	[CmdletBinding()]
	param(
		[switch]$IncludeIgnored
    )

	_enterConsoleWorkingDirectory {
		param($IncludeIgnored)
		_updateGitHubRemotes | Out-Null

		Write-Host -ForegroundColor Cyan "Currently on branch:"
		Write-Host -ForegroundColor Red "`t$(_getCurrentLocalBranch)"

		Write-Host -ForegroundColor Cyan "`nRemote tracking branches..."
		& git branch --remotes | Write-Host

		Write-Host -ForegroundColor Cyan "`nLocal branches..."
		& git branch --list | Write-Host

		Write-Host -ForegroundColor Cyan "`nBranch structure..."

		Write-Host -ForegroundColor Cyan "`nShow uncommited changes..."
    	$optionalArguments = @()
    	if ($IncludeIgnored) { $optionalArguments += @("--ignored") }
		& git status --short --branch --untracked-files=all @optionalArguments | Write-Host
    } $IncludeIgnored | Write-Host
}