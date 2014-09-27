function Show-ConsoleStatus {
    Push-Location $ProfileConfig.General.InstallPath
    try {
		& git status
    }
	finally {
		Pop-Location
	}
}