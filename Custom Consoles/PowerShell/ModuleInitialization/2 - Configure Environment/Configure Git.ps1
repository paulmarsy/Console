param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

$Path = @(
	(Join-Path $PowerShellConsoleConstants.GitInstallPath "cmd")
	$Env:PATH
) -Join ';'

[System.Environment]::SetEnvironmentVariable("PATH", $Path, [System.EnvironmentVariableTarget]::Process)

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

    & git.exe config --file "$gitConfigFileLocation" $Name $Value
}

# Set the user details
SetGitConfig "user.name" $ProfileConfig.Git.Name
SetGitConfig "user.email" $ProfileConfig.Git.Email
