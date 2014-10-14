function Reinstall-Console {
	param(
		[switch]$AutomatedReinstall
	)
	
	Start-Process -FilePath "##HStartPath##" -ArgumentList "/ELEVATE """"##InternalInstallFile##"" -StartAfterInstall $(if ($AutomatedReinstall) { "-AutomatedReinstall" }) """
	$Host.SetShouldExit(0)
}