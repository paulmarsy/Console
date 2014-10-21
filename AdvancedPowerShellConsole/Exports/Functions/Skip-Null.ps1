filter Skip-Null {
	[CmdletBinding(DefaultParameterSetName="IsNull")]
	param(
		[Parameter(ParameterSetName="IsNull")][switch]$IsNull,
		[Parameter(ParameterSetName="OrEmpty")][switch]$OrEmpty,
		[Parameter(ParameterSetName="OrWhiteSpace")][switch]$OrWhiteSpace
	)
	
	$_ | ? {
		switch ($PsCmdlet.ParameterSetName) {
			"IsNull" { return ($null -ne $_) }
			"OrEmpty" { return (-not ([string]::IsNullOrEmpty($_))) }
			"OrWhiteSpace" { return (-not ([string]::IsNullOrWhiteSpace($_))) }
		}
	}
} 