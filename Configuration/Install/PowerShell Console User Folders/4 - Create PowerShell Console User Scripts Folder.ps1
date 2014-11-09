Invoke-InstallStep "Creating User Scripts Folder" {
	if (-not (Test-Path $PowerShellConsoleContstants.UserFolders.UserScriptsFolder)) {
		New-Item $PowerShellConsoleContstants.UserFolders.UserScriptsFolder -Type Directory -Force | Out-Null
	}

	if (-not (Test-Path $PowerShellConsoleContstants.UserFolders.UserScriptsAutoFolder)) {
		New-Item $PowerShellConsoleContstants.UserFolders.UserScriptsAutoFolder -Type Directory -Force | Out-Null
	}
}

if (-not (Test-Path $PowerShellConsoleContstants.UserFolders.UserScriptsIncludeFile)) {
	Invoke-InstallStep "Creating empty include.ps1 file in PowerShell Scripts Folder" {
		Set-Content -LiteralPath $PowerShellConsoleContstants.UserFolders.UserScriptsIncludeFile -Value $null
	}
}