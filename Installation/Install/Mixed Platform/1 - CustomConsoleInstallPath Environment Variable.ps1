Invoke-InstallStep "Creating CustomConsolesInstallPath environment variable" {
	[System.Environment]::SetEnvironmentVariable("CustomConsolesInstallPath", $PowerShellConsoleConstants.InstallPath, [System.EnvironmentVariableTarget]::User)
}