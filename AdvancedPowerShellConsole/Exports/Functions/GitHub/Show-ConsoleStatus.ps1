function Show-ConsoleStatus {
    Push-Location $ProfileConfig.General.InstallPath
    try {
    	Start-Process -FilePath "git.exe" -ArgumentList "remote update" -WindowStyle Hidden
		& git status
    }
	finally {
		Pop-Location
	}
}