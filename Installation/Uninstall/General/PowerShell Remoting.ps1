Invoke-InstallStep "Disabling PowerShell Remoting" {
	Disable-PSRemoting -Force -WarningAction Ignore
	Disable-WSManCredSSP -Role Client
	Disable-WSManCredSSP -Role Server
}