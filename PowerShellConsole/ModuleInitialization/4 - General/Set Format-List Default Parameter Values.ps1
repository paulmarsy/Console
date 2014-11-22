param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $false}) }

$Global:PSDefaultParameterValues.Add("Format-List:Property", "*")
$Global:PSDefaultParameterValues.Add("Format-List:Expand", "Both")
$Global:PSDefaultParameterValues.Add("Format-List:Force", $true)