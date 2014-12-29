param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = -1; Critical = $true}) }

$PowerShellConsoleConstants = & (Join-Path $InstallPath "Config\Constants.ps1")