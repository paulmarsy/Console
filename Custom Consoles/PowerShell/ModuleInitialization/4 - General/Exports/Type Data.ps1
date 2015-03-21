param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

Get-ChildItem -Path (Join-Path $ProfileConfig.ConsolePaths.PowerShell "Exports\Type Data") -File -Filter "*.ps1" | % {
	$baseName = $_.BaseName
	$typeExtensionData = & "$($_.FullName)"

	if ($typeExtensionData -isnot [array]) {
		$typeExtensionData = @($typeExtensionData)
	}

	$typeExtensionData | % {
		if ($_.ContainsKey("TypeName")) {
			if ($_.TypeName -isnot [array]) {
				$typeNames = @($_.TypeName)
			} else {
				$typeNames = $_.TypeName
			}
			$_.Remove("TypeName")
		} else {
			$typeNames = @($baseName)
		}
		
		$typeData = $_
		$typeNames | % { Update-TypeData -TypeName $_ -Force @typeData }
	}
}

Get-ChildItem -Path (Join-Path $ProfileConfig.ConsolePaths.PowerShell "Exports\Type Data") -File -Filter "*.types.ps1xml" | % {
	Update-TypeData -PrependPath $_.FullName
}