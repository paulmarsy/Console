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

		Write-Host -ForegroundColor Cyan "`nShow uncommited changes..."
    	$optionalArguments = @()
    	if ($IncludeIgnored) { $optionalArguments += @("--ignored") }
		& git status --short --branch --untracked-files=all @optionalArguments
    } $IncludeIgnored
}