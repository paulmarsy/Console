param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return 2 }

$Global:PSEmailServer = $ProfileConfig.PowerShell.PSEmailServer
$Global:FormatEnumerationLimit = $ProfileConfig.PowerShell.FormatEnumerationLimit