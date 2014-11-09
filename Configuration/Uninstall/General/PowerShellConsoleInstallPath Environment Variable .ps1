Invoke-InstallStep "Removing PowerShellConsoleInstallPath environment variable" {
	[System.Environment]::SetEnvironmentVariable("PowerShellConsoleInstallPath", $null, [System.EnvironmentVariableTarget]::User)
}