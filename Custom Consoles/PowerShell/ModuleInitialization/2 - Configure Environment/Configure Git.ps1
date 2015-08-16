param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

$gitPath = Join-Path $PowerShellConsoleConstants.GitInstallPath "cmd"
$gitFile =  Join-Path $gitPath "git.exe"

if (-not (Test-Path $gitFile)) {
	throw "Unable to find git.exe in the location: ''$gitFile'"
}

$Path = @(
	$gitPath
	$Env:PATH
) -Join ';'

[System.Environment]::SetEnvironmentVariable("PATH", $Path, [System.EnvironmentVariableTarget]::Process)
[System.Environment]::SetEnvironmentVariable("ConEmuGitPath", $gitPath, [System.EnvironmentVariableTarget]::Process)

$gitConfigFileLocation = Join-Path $ProfileConfig.Module.AppSettingsFolder "Gitconfig.config"
$gitConfigLockFileLocation = [System.IO.Path]::ChangeExtension($gitConfigFileLocation, "config.lock")
if (Test-Path $gitConfigLockFileLocation) {
	Remove-Item -Path $gitConfigLockFileLocation -Force
}

function SetGitConfig {
	param(
		$Name,
        $Value
    )

    & $gitFile config --file "$gitConfigFileLocation" $Name $Value
}

# Set the user details
SetGitConfig "user.name" $ProfileConfig.Git.Name
SetGitConfig "user.email" $ProfileConfig.Git.Email