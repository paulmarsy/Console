param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

Export-Module HistoryPx

Set-ExtendedHistoryConfiguration -MaximumEntryCount $MaximumHistoryCount