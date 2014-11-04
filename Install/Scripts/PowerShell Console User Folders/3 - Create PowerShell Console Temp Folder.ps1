Invoke-InstallStep "Creating PowerShell Temp Folder" {
	if (-not (Test-Path $PowerShellConsoleContstants.UserFolders.TempFolder)) {
		New-Item $PowerShellConsoleContstants.UserFolders.TempFolder -Type Directory -Force | Out-Null
	}

	if (Get-ChildItem -Path $PowerShellConsoleContstants.UserFolders.TempFolder) {
		Write-InstallMessage -Type Warning "Existing files detected in the PowerShell Temp folder"
	}
}