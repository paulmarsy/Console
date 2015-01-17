Invoke-InstallStep "Redirecting SmartGit settings directory" {
	$smartGitSettingsParentDir = Join-Path $Env:APPDATA "syntevo"
	if (-not (Test-Path $smartGitSettingsParentDir)) {
		New-Item $smartGitSettingsParentDir -Type Directory -Force | Out-Null
	}

	$customSmartGitSettingsDirectory = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "SmartGit"
	$defaultSmartGitSettingsDirectory = Join-Path $smartGitSettingsParentDir "SmartGit"
	ConvertTo-DirectoryJunction -JunctionPath $defaultSmartGitSettingsDirectory -TargetPath $customSmartGitSettingsDirectory
}
