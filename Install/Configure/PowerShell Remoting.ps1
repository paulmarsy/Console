"Enabling PowerShell Remoting..."
Enable-PSRemoting -SkipNetworkProfileCheck -Force
Enable-WSManCredSSP -Role Client -DelegateComputer * -Force | Out-Null
Enable-WSManCredSSP -Role Server -Force | Out-Null