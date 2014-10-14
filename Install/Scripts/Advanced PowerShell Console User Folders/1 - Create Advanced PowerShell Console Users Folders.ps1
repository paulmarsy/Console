Invoke-InstallStep "Creating Users Folders" {
	if (-not (Test-Path $AdvancedPowerShellConsoleUserFolder)) {
		New-Item $AdvancedPowerShellConsoleUserFolder -Type Directory -Force | Out-Null
	}
}