param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return 2 }

Import-UserScripts -ModuleInit