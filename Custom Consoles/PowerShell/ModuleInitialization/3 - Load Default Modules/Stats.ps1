param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

Export-Module -ModuleName "Stats" -ModuleFile (Join-Path $ModuleHelpersFolder "Stats.psm1") -ArgumentList $PowerShellConsoleConstants.UserFolders.AppSettingsFolder