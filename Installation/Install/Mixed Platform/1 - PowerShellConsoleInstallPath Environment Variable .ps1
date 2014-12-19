Invoke-InstallStep "Creating PowerShellConsoleInstallPath environment variable" {
	[System.Environment]::SetEnvironmentVariable("PowerShellConsoleInstallPath", $PowerShellConsoleConstants.InstallPath, [System.EnvironmentVariableTarget]::User)
}