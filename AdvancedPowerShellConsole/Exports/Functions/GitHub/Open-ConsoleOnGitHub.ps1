function Open-ConsoleOnGitHub {
    Push-Location $ProfileConfig.General.InstallPath
    try {
    	Open-Location -Location ConsoleGitHub
    }
	finally {
		Pop-Location
	}
}