Invoke-InstallStep "Creating Users Folders" {
	if (-not (Test-Path $PowerShellConsoleUserFolder)) {
		New-Item $PowerShellConsoleUserFolder -Type Directory -Force | Out-Null
	}
}