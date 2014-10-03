function Show-ConsoleStatus {
	[CmdletBinding()]
	param(
		[switch]$IncludeIgnored
    )

	_enterConsoleWorkingDirectory {
		param($IncludeIgnored)
		_updateGitHub | Out-Null

		Write-Host -ForegroundColor Cyan "Remote tracking branches..."
		& git branch --remotes

		Write-Host -ForegroundColor Cyan "`nLocal branches..."
		& git branch --list

		Write-Host -ForegroundColor Cyan "`nBranch structure..."

		$currentBranch = & git rev-parse --abbrev-ref HEAD
		Write-Host -ForegroundColor Cyan "`nCurrently on branch $currentBranch"

		Write-Host -ForegroundColor Cyan "`nShow uncommited changes..."
    	$optionalArguments = @()
    	if ($IncludeIgnored) { $optionalArguments += @("--ignored") }
		& git status --short --branch --untracked-files=all @optionalArguments
    } $IncludeIgnored
}