param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $false}) }

# Update PSModulePath to reference 'PowerShell Modules' directory
$newPSModulePath = $Env:PSModulePath + ([System.IO.Path]::PathSeparator) + (Join-Path $ProfileConfig.Module.InstallPath "Libraries\PowerShell Modules")
[System.Environment]::SetEnvironmentVariable("PSModulePath", $newPSModulePath, [System.EnvironmentVariableTarget]::Process)