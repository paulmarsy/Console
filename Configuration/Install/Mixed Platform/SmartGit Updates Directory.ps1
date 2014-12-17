Invoke-InstallStep "Redirecting SmartGit updates directory" {

	$smartGitCustomSettingsPath = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "SmartGit"
	if (-not (Test-Path $smartGitCustomSettingsPath)) {
		New-Item $smartGitCustomSettingsPath -Type Directory -Force | Out-Null
	}

	@("updates", "updater") | % {
		$originalPath = Join-Path $smartGitCustomSettingsPath $_
		if (Test-Path $originalPath) {
			& cmd.exe /Q /C	rmdir "$originalPath" *>$null
			if ($LASTEXITCODE -ne 0) {
				throw "Unable to remove existing symbolic link to SmartGit $_ directory (exit code $LASTEXITCODE)"
			}
		}

		$redirectedPath = Join-Path $Env:TEMP "SmartGit-$($_)"
		if (-not (Test-Path $redirectedPath)) {
			New-Item $redirectedPath -Type Directory -Force | Out-Null
		}
		& cmd.exe /Q /C mklink /D "$originalPath" "$redirectedPath" *>$null
		if ($LASTEXITCODE -ne 0) {
			throw "Unable to create symbolic link to custom SmartGit $_ directory (exit code $LASTEXITCODE)"
		}
	}
}

