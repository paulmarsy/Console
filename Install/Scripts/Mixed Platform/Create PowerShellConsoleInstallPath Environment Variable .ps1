Invoke-InstallStep "Creating PowerShellConsoleInstallPath environment variable" {
	[System.Environment]::SetEnvironmentVariable("PowerShellConsoleInstallPath", $PowerShellConsoleContstants.InstallPath, [System.EnvironmentVariableTarget]::User)
}