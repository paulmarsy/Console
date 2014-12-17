Invoke-InstallStep "Creating User Scripts Folder" {
	if (-not (Test-Path $PowerShellConsoleConstants.UserFolders.UserScriptsFolder)) {
		New-Item $PowerShellConsoleConstants.UserFolders.UserScriptsFolder -Type Directory -Force | Out-Null
	}

	if (-not (Test-Path $PowerShellConsoleConstants.UserFolders.UserScriptsAutoFolder)) {
		New-Item $PowerShellConsoleConstants.UserFolders.UserScriptsAutoFolder -Type Directory -Force | Out-Null
	}
}

if (-not (Test-Path $PowerShellConsoleConstants.UserFolders.UserScriptsIncludeFile)) {
	Invoke-InstallStep "Creating empty include.ps1 file in PowerShell Scripts Folder" {
		Set-Content -LiteralPath $PowerShellConsoleConstants.UserFolders.UserScriptsIncludeFile -Value $null
	}
}