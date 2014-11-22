param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

Import-Module Show-Ast -Global