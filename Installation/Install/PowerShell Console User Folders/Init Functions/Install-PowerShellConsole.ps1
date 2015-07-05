function Install-PowerShellConsole {
	Start-Process -FilePath "##HStartPath##" -ArgumentList "/ELEVATE """"##InternalInstallFile##"" -StartAfterInstall $(if ($AutomatedReinstall) { "-AutomatedReinstall" }) """
	Start-Process -FilePath "##ConEmuCExecutablePath##" -ArgumentList "-GuiMacro Close(7)" -Wait -NoNewWindow
	Get-Host | % SetShouldExit 0
}