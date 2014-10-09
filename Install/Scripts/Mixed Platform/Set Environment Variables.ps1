Invoke-InstallStep "Setting Environment Variables" {
	[System.Environment]::SetEnvironmentVariable("AdvancedPowerShellConsoleInstallPath", $InstallPath, [System.EnvironmentVariableTarget]::User)
}