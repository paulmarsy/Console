Invoke-InstallStep "Updating installed version file" {
	Set-Content -Path $PowerShellConsoleConstants.Version.InstalledFile -Value $PowerShellConsoleConstants.Version.CurrentVersion
}