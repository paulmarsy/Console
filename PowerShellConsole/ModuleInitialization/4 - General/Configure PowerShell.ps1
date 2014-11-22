param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

$Global:PSEmailServer = $ProfileConfig.PowerShell.PSEmailServer
$Global:FormatEnumerationLimit = $ProfileConfig.PowerShell.FormatEnumerationLimit