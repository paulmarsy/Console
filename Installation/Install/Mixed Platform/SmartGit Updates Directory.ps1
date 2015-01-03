Invoke-InstallStep "Redirecting SmartGit updates directory" {

	$smartGitCustomSettingsPath = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "SmartGit"
	if (-not (Test-Path $smartGitCustomSettingsPath)) {
		New-Item $smartGitCustomSettingsPath -Type Directory -Force | Out-Null
	}

	@("updates", "updater") | % {
		$redirectedPath = Join-Path $Env:TEMP "SmartGit-$($_)"
		if (-not (Test-Path $redirectedPath)) {
			New-Item $redirectedPath -Type Directory -Force | Out-Null
		}

		$originalPath = Join-Path $smartGitCustomSettingsPath $_
		if (Test-Path $originalPath) {
			if ([bool]((Get-Item -Path $originalPath | % Attributes) -band [IO.FileAttributes]::ReparsePoint)) {
				& cmd.exe /Q /C	rmdir "$originalPath" *>$null
				if ($LASTEXITCODE -ne 0) {
					throw "Unable to remove existing symbolic link to SmartGit $_ directory (exit code $LASTEXITCODE)"
				}
			} else {
				Get-ChildItem -Path $originalPath -Force | % { Move-Item -Path $_.FullName -Destination $redirectedPath -Force }

				$remainingFiles = Get-ChildItem -Path $originalPath -Force | Measure-Object -Line | Select-Object -ExpandProperty Lines
				if ($remainingFiles -ge 1) {
					throw "$remainingFiles files still exist in the original SmartGit folder, please manually move them"
				}

				Remove-Item -Path $originalPath -Recurse -Force
			}
		}

		& cmd.exe /Q /C mklink /D "$originalPath" "$redirectedPath" *>$null
		if ($LASTEXITCODE -ne 0) {
			throw "Unable to create symbolic link to custom SmartGit $_ directory (exit code $LASTEXITCODE)"
		}
	}
}

