filter Skip-Null {
	param(
		[Parameter(ParameterSetName="OrEmpty")][switch]$OrEmpty,
		[Parameter(ParameterSetName="OrWhiteSpace")][switch]$OrWhiteSpace
	)
	
	$_ | ? {
		if ($OrEmpty) { return (-not ([string]::IsNullOrEmpty($_))) }
		elseif ($OrWhiteSpace) { return (-not ([string]::IsNullOrWhiteSpace($_))) }
		else { return ($null -ne $_) }
	}
} 