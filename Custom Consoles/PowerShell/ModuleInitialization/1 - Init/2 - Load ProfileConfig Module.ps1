param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = -1; Critical = $true}) }

Export-Module -ModuleName "ProfileConfig" -ModuleFile (Join-Path $ExecutionContext.SessionState.Module.ModuleBase "ProfileConfig")