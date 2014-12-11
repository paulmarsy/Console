param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

Update-FormatData -PrependPath (Join-Path $ProfileConfig.Module.InstallPath "Libraries\Misc\ErrorInstance.ps1xml")