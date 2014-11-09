Invoke-InstallStep "Creating Users Folders" {
	if (-not (Test-Path $PowerShellConsoleContstants.UserFolders.Root)) {
		New-Item $PowerShellConsoleContstants.UserFolders.Root -Type Directory -Force | Out-Null
	}
}