Invoke-InstallStep "Updating SmartGit settings directory" {

	$smartGitCustomSettingsPath = Join-Path $PowerShellConsoleContstants.UserFolders.AppSettingsFolder "SmartGit"
	if (-not (Test-Path $smartGitCustomSettingsPath)) {
		New-Item $smartGitCustomSettingsPath -Type Directory -Force | Out-Null
	}

	$smartGitSettingsParentDir = Join-Path $Env:APPDATA "syntevo"
	if (-not (Test-Path $smartGitSettingsParentDir)) {
		New-Item $smartGitSettingsParentDir -Type Directory -Force | Out-Null
	}

	$smartGitSettingsDir = Join-Path $smartGitSettingsParentDir "SmartGit"
	if (Test-Path $smartGitSettingsDir) {
		& cmd.exe /Q /C	rmdir "$smartGitSettingsDir" *>$null
		if ($LASTEXITCODE -ne 0) {
			throw "Unable to remove existing symbolic link to custom SmartGit settings directory (exit code $LASTEXITCODE)"
		}
	}

	& cmd.exe /Q /C mklink /D "$smartGitSettingsDir" "$smartGitCustomSettingsPath" *>$null
	if ($LASTEXITCODE -ne 0) {
		throw "Unable to create symbolic link to custom SmartGit settings directory (exit code $LASTEXITCODE)"
	}
}

