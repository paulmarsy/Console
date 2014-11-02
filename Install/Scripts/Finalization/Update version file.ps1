Invoke-InstallStep "Updating installed version file" {
	Set-Content -Path $PowerShellConsoleVersionFile -Value $PowerShellConsoleVersion
}