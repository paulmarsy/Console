function Publish-ConsoleBranch {
	[CmdletBinding()]
	param(
		[switch]$IncludeIgnored
    )

    Push-Location $ProfileConfig.General.InstallPath
    try {
    	Start-Process -FilePath "git.exe" -ArgumentList "remote update" -WindowStyle Hidden -Wait

		Write-Host -ForegroundColor Cyan "Remote tracking branches..."
		& git branch --remotes

		Write-Host -ForegroundColor Cyan "`nLocal branches..."
		& git branch --list

		Write-Host -ForegroundColor Cyan "`nShow uncommited changes..."
    	$optionalArguments = @()
    	if ($IncludeIgnored) { $optionalArguments += @("--ignored") }
		& git status --short --branch --untracked-files=all @optionalArguments
    }
	finally {
		Pop-Location
	}
}