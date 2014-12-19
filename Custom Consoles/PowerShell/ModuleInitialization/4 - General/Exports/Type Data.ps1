param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

Get-ChildItem -Path (Join-Path $ProfileConfig.ConsolePaths.PowerShell "Exports\Type Data") -File -Filter *.ps1 | % {
	$typeName = $_.BaseName
	$typeExtensionData = & "$($_.FullName)"

	if ($typeExtensionData -isnot [array]) {
		$typeExtensionData = @($typeExtensionData)
	}

	$typeExtensionData | % { Update-TypeData -TypeName $typeName -Force @_ }
}

Get-ChildItem -Path (Join-Path $ProfileConfig.ConsolePaths.PowerShell "Exports\Type Data") -File -Filter *.types.ps1xml | % {
	Update-TypeData -PrependPath $_.FullName
}