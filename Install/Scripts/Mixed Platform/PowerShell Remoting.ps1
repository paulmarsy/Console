Invoke-InstallStep "Enabling PowerShell Remoting" {
	Enable-PSRemoting -SkipNetworkProfileCheck -Force | Out-Null
	Enable-WSManCredSSP -Role Client -DelegateComputer * -Force | Out-Null
	Enable-WSManCredSSP -Role Server -Force | Out-Null
}