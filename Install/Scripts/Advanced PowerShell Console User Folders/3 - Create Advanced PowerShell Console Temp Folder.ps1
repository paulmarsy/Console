Invoke-InstallStep "Creating PowerShell Temp Folder" {
	if (-not (Test-Path $AdvancedPowerShellConsoleTempFolder)) {
		New-Item $AdvancedPowerShellConsoleTempFolder -Type Directory -Force | Out-Null
	}

	if (Get-ChildItem -Path $AdvancedPowerShellConsoleTempFolder) {
		Write-InstallMessage -Type Warning "Existing files detected in the PowerShell Temp folder"
	}
}