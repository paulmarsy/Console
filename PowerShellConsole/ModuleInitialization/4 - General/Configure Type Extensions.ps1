param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

Get-ChildItem -Path (Join-Path $ProfileConfig.ConsolePaths.PowerShell "Exports\Type Extensions") -Filter *.ps1 | % {
	$typeName = $_.BaseName
	$typeExtensionData = & "$($_.FullName)"

	if ($typeExtensionData -isnot [array]) {
		$typeExtensionData = @($typeExtensionData)
	}

	$typeExtensionData | % { Update-TypeData -TypeName $typeName -Force @_ }
}