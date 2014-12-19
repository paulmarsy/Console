function Uninstall-PowerShellConsole {
	Start-Process -FilePath "##HStartPath##" -ArgumentList "/ELEVATE """"##InternalUninstallFile##"""""
	[System.Environment]::Exit(0)
}