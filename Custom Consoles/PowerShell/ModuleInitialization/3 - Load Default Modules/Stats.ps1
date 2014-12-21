param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

Import-Module (Join-Path $ModuleHelpersFolder "Stats.psm1") -ArgumentList $PowerShellConsoleConstants.UserFolders.AppSettingsFolder -Force