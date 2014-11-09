Invoke-InstallStep "Updating installed version file" {
	Set-Content -Path $PowerShellConsoleContstants.Version.InstalledFile -Value $PowerShellConsoleContstants.Version.CurrentVersion
}