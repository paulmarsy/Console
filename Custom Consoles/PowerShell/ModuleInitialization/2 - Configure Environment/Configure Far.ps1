param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

$Path = @(
	$Env:PATH
	(Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Far")
) -Join ";"

[System.Environment]::SetEnvironmentVariable("PATH", $Path, [System.EnvironmentVariableTarget]::Process)
