function Uninstall-PowerShellConsole {
	Start-Process -FilePath "##HStartPath##" -ArgumentList "/ELEVATE """"##InternalUninstallFile##"""""
	Start-Process -FilePath "##ConEmuCExecutablePath##" -ArgumentList "-GuiMacro Close(7)" -Wait -WindowStyle Hidden
	Get-Host | % SetShouldExit 0
}