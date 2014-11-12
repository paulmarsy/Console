$Path = @(
	(Join-Path $PowerShellConsoleConstants.GitInstallPath "bin")
	(Join-Path $PowerShellConsoleConstants.GitInstallPath "mingw\bin")
	(Join-Path $PowerShellConsoleConstants.GitInstallPath "cmd")
	$Env:PATH
) -Join ';'

[System.Environment]::SetEnvironmentVariable("PATH", $Path, [System.EnvironmentVariableTarget]::Process)


# Stop pull requests from being fetched
& git.exe config --system --unset-all remote.origin.fetch .*refs\/pull\/\*.*:.*\/origin\/pr\/\*.*

$gitConfigFileLocation = Join-Path $ProfileConfig.Module.AppSettingsFolder "Gitconfig.config"

try {
	Push-Location $ProfileConfig.Module.InstallPath
	& git.exe config --local "include.path" $gitConfigFileLocation
}
finally {
	Pop-Location
}

function SetGitConfig {
	param(
		$Name,
        $Value
    )

    & git.exe config --file "$gitConfigFileLocation" $Name $Value
}

SetGitConfig "user.name" $ProfileConfig.Git.Name
SetGitConfig "user.email" $ProfileConfig.Git.Email
SetGitConfig "core.ignorecase" "true"
SetGitConfig "core.autocrlf" "true" 
SetGitConfig "core.editor" "'$($PowerShellConsoleConstants.Executables.SublimeText)' -w"
SetGitConfig "diff.renames" "true"
SetGitConfig "diff.tool" "bc4"
SetGitConfig "merge.tool" "bc3"
SetGitConfig "pager.log" "false"

$gitHubForWindowsInstallPath = Get-ItemProperty -Path "HKCU:\Software\Classes\github-windows\shell\open\command" | % "(default)" | Split-Path -Parent | % Trim '"'

& (Join-Path $gitHubForWindowsInstallPath GitHub.exe) --set-up-ssh