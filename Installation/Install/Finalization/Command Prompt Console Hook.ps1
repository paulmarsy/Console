Invoke-InstallStep "Configuring Command Prompt Console Hook" {	
	if (-not (Test-Path "HKCU:\Software\Microsoft\Command Processor")) {
		New-Item "HKCU:\Software\Microsoft\Command Processor" -Force | Out-Null
	}
	
	New-ItemProperty "HKCU:\Software\Microsoft\Command Processor" "AutoRun" -Value "`"$($PowerShellConsoleConstants.HookFiles.CommandPrompt)`"" -Type String -Force | Out-Null
}