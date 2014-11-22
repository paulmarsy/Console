param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return 3 }

$Global:PSDefaultParameterValues.Add("Format-List:Property", "*")
$Global:PSDefaultParameterValues.Add("Format-List:Expand", "Both")
$Global:PSDefaultParameterValues.Add("Format-List:Force", $true)