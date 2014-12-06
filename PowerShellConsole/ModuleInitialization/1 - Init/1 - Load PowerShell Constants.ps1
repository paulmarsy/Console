param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = -1; Critical = $true}) }

$PowerShellConsoleConstants = & (Join-Path $InstallPath "Constants.ps1")