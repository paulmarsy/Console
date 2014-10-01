function Publish-ConsoleBranch {
	[CmdletBinding()]
	param(
		[switch]$IncludeIgnored
    )

    Push-Location $ProfileConfig.General.InstallPath
    try {
    }
	finally {
		Pop-Location
	}
}