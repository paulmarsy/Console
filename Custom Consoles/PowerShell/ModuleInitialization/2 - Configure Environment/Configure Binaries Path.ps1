param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $false}) }

# Update PATH to reference 'Binaries' directory and subdirectories
$Path = @(
	$Env:PATH
	(Join-Path $ProfileConfig.Module.InstallPath "Libraries\Binaries")
	(Get-ChildItem -Path (Join-Path $ProfileConfig.Module.InstallPath "Libraries\Binaries") | ? PSIsContainer | Select-Object -ExpandProperty FullName) 
) -Join ";"

[System.Environment]::SetEnvironmentVariable("PATH", $Path, [System.EnvironmentVariableTarget]::Process)