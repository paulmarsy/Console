param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $false}) }

$pathExtensionsDir = Join-Path $ProfileConfig.Module.InstallPath "Libraries\PATH Extensions"

$Path = @(
	$Env:PATH
	$pathExtensionsDir
	(Get-ChildItem -Path $pathExtensionsDir -Directory | % FullName) 
) -Join ";"

[System.Environment]::SetEnvironmentVariable("PATH", $Path, [System.EnvironmentVariableTarget]::Process)