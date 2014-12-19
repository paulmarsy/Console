function Uninstall-PowerShellConsole {
	Start-Process -FilePath "##HStartPath##" -ArgumentList "/ELEVATE """"##InternalInstallFile##"" -StartAfterInstall $(if ($AutomatedReinstall) { "-AutomatedReinstall" }) """
	[System.Environment]::Exit(0)
}