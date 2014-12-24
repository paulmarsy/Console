param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $false}) }

$Path = @(
	$Env:PATH
	(Join-Path $ProfileConfig.Module.InstallPath "Libraries\PATH Extensions")
	(Get-ChildItem -Path (Join-Path $ProfileConfig.Module.InstallPath "Libraries\PATH Extensions") -Directory | Select-Object -ExpandProperty FullName) 
) -Join ";"

[System.Environment]::SetEnvironmentVariable("PATH", $Path, [System.EnvironmentVariableTarget]::Process)