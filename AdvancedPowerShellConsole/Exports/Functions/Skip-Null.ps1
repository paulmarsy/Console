function Skip-Null {
	[CmdletBinding(DefaultParameterSetName="IsNull")]
	param(
		[Parameter(ValueFromPipeline = $true)]$InputObject,
		[Parameter(ParameterSetName="IsNull")][switch]$IsNull,
		[Parameter(ParameterSetName="OrEmpty")][switch]$OrEmpty,
		[Parameter(ParameterSetName="OrWhiteSpace")][switch]$OrWhiteSpace
	)
	
	PROCESS {
		$InputObject | foreach {
			$current = $_
			$shouldSkip = switch ($PsCmdlet.ParameterSetName) {
				"IsNull" { $null -eq $current }
				"OrEmpty" { [string]::IsNullOrEmpty($current) }
				"OrWhiteSpace" { [string]::IsNullOrWhiteSpace($current) }
			}
			if ($shouldSkip) { continue }
			else { return $current }
		}
	}
}