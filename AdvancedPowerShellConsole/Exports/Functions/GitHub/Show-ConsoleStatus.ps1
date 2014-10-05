function Show-ConsoleStatus {
	[CmdletBinding()]
	param(
		[switch]$IncludeIgnored
    )

	_enterConsoleWorkingDirectory {
		param($IncludeIgnored)
		_updateGitHub | Out-Null

		$currentBranch = & git rev-parse --abbrev-ref HEAD
		Write-Host -ForegroundColor Magenta "Currently on branch $currentBranch"

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