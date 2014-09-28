function Show-ConsoleStatus {
	[CmdletBinding()]
	param(
		[switch]$IncludeIgnored
    )

    Push-Location $ProfileConfig.General.InstallPath
    try {
    	Start-Process -FilePath "git.exe" -ArgumentList "remote update" -WindowStyle Hidden -Wait
    	$optionalArguments = @()
    	if ($IncludeIgnored) { $optionalArguments += @("--ignored") }
		& git status --short --branch --untracked-files=all @optionalArguments
    }
	finally {
		Pop-Location
	}
}