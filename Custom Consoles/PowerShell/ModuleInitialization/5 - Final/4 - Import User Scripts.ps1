param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

Import-UserScripts -ModuleInit