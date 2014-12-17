Invoke-InstallStep "Creating PowerShell Temp Folder" {
	if (-not (Test-Path $PowerShellConsoleConstants.UserFolders.TempFolder)) {
		New-Item $PowerShellConsoleConstants.UserFolders.TempFolder -Type Directory -Force | Out-Null
	}

	if (Get-ChildItem -Path $PowerShellConsoleConstants.UserFolders.TempFolder) {
		Write-InstallMessage -Type Warning "Existing files detected in the PowerShell Temp folder"
	}
}