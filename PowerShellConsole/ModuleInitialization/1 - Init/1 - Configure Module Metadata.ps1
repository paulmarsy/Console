param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return -1 }

$ExecutionContext.SessionState.Module.AccessMode = [System.Management.Automation.ModuleAccessMode]::ReadOnly