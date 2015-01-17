Invoke-InstallStep "Redirecting SmartGit updates directory" {
	$smartGitCustomSettingsPath = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "SmartGit"

	@("updates", "updater") | % {
		$redirectedPath = Join-Path $Env:TEMP "SmartGit-$($_)"
		$originalPath = Join-Path $smartGitCustomSettingsPath $_
		ConvertTo-DirectoryJunction -JunctionPath $originalPath -TargetPath $redirectedPath
	}
}
