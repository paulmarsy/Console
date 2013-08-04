"Enabling PowerShell Remoting..."
Enable-PSRemoting -Force
Enable-WSManCredSSP -Role Client –DelegateComputer * -Force | Out-Null
Enable-WSManCredSSP -Role Server –Force | Out-Null