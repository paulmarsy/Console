param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

Export-Module PowerForensics (Join-Path $ProfileConfig.Module.InstallPath "Libraries\PowerShell Modules\PowerForensics\PowerForensics\Module\PowerForensics")