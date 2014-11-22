param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return -1 }

$PowerShellConsoleConstants = & (Join-Path $InstallPath "Constants.ps1")