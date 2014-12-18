param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

Get-ChildItem -Path (Join-Path $ProfileConfig.ConsolePaths.PowerShell "Exports\Default Parameter Values") -File -Filter *.ps1 | % {
	$functionName = $_.BaseName
	$functionDefaultParameters = & "$($_.FullName)"

	if ($functionDefaultParameters -isnot [array]) {
		$functionDefaultParameters = @($functionDefaultParameters)
	}

	$functionDefaultParameters | % {
		$keyName = "{0}:{1}" -f $functionName, $_.Property
		if ($Global:PSDefaultParameterValues.Contains($keyName)) {
			$Global:PSDefaultParameterValues.Remove($keyName)
		}
		$Global:PSDefaultParameterValues.Add($keyName, $_.Value)
	}
}