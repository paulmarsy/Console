Invoke-InstallStep "Creating PowerShell Temp Folder" {
	if (-not (Test-Path $PowerShellConsoleTempFolder)) {
		New-Item $PowerShellConsoleTempFolder -Type Directory -Force | Out-Null
	}

	if (Get-ChildItem -Path $PowerShellConsoleTempFolder) {
		Write-InstallMessage -Type Warning "Existing files detected in the PowerShell Temp folder"
	}
}