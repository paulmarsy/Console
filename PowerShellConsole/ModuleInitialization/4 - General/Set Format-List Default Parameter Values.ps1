param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $false}) }

function Update-PSDefaultParameterValues {
	param($Name, $Value)

	if ($Global:PSDefaultParameterValues.ContainsKey($Name)) {
		$Global:PSDefaultParameterValues.Remove($Name)
	}
	$Global:PSDefaultParameterValues.Add($Name, $Value)
}

Update-PSDefaultParameterValues "Format-List:Property" "*"
Update-PSDefaultParameterValues "Format-List:Expand" "Both"
Update-PSDefaultParameterValues "Format-List:Force" $true