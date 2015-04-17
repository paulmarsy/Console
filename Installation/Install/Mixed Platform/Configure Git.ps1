Invoke-InstallStep "Configuring Git" {
	$git = @(
		(Join-Path $PowerShellConsoleConstants.GitInstallPath "bin")
		(Join-Path $PowerShellConsoleConstants.GitInstallPath "mingw\bin")
		(Join-Path $PowerShellConsoleConstants.GitInstallPath "cmd")
	) |
		? { Test-Path -Path $_ } |
		Get-ChildItem -Filter "git.exe" -File |
		Select-Object -First 1 -ExpandProperty FullName

	# Stop pull requests from being fetched
	& $git config --system --unset-all remote.origin.fetch .*refs\/pull\/\*.*:.*\/origin\/pr\/\*.*
	& $git config --global push.default simple # Enabling recommended Git behaviour where only the current branch is pushed if no branch is specified

	$gitConfigFileLocation = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "Gitconfig.config"
	$gitConfigLockFileLocation = [System.IO.Path]::ChangeExtension($gitConfigFileLocation, "config.lock")
	if (Test-Path $gitConfigLockFileLocation) {
		Remove-Item -Path $gitConfigLockFileLocation -Force
	}
	
	try {
		Push-Location $PowerShellConsoleConstants.InstallPath
		@(
			$PowerShellConsoleConstants.InstallPath
			(& $git submodule foreach --quiet 'echo $toplevel/$path' | % Replace -ArgumentList @('/', '\'))
		) | % {
			Set-Location $_
			& $git config --local "include.path" $gitConfigFileLocation
		}
	}
	finally {
		Pop-Location
	}

	function SetGitConfig {
		param(
			$Name,
	        $Value
	    )

	    & $git config --file "$gitConfigFileLocation" $Name $Value
	}

	# General tweaks
	SetGitConfig "core.ignorecase" "true"
	SetGitConfig "core.autocrlf" "false" 
	SetGitConfig "core.editor" "'$($PowerShellConsoleConstants.Executables.Atom)'"
	SetGitConfig "diff.renames" "true"
	SetGitConfig "color.ui" "always"

	# Performance tweaks
	SetGitConfig "core.preloadindex" "true" # Enable parallel index preload for operations like git diff
	SetGitConfig "core.fscache" "true" # Enable additional caching of file system data for some operations. Git for Windows uses this to bulk-read and cache lstat data of entire directories (instead of doing lstat file by file).

	# Use Beyond Compare as the merge / diff tool
	SetGitConfig "diff.tool" "bc4"
	SetGitConfig "difftool.bc4.cmd" "\`"$((${Env:ProgramFiles(x86)}).Replace("\", "/"))/Beyond Compare 4/bcomp.exe\`" \`"`$LOCAL\`" \`"`$REMOTE\`""
	SetGitConfig "merge.tool" "bc4"
	SetGitConfig "mergetool.bc4.cmd" "\`"$((${Env:ProgramFiles(x86)}).Replace("\", "/"))/Beyond Compare 4/bcomp.exe\`" \`"`$LOCAL\`" \`"`$REMOTE\`" \`"`$BASE\`" \`"`$MERGED\`""
	SetGitConfig "mergetool.bc4.trustExitCode" "true"

	# Misc
	SetGitConfig "diff.submodule" "log" # Add submodule information to superproject's diff log command
	SetGitConfig "status.submodulesummary" 1 # Add submodule information to the superproject's status command
	SetGitConfig "pager.log" "false" # Disable pagination when viewing log files (to improve script interactivity)
	
	$credentialHelper = "`"!'{0}'`"" -f (Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Misc\git-credential-winstore.exe")
	SetGitConfig "credential.helper" $credentialHelper
}