param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return 1 }

Import-Module Show-Ast -Global