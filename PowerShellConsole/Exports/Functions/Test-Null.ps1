function Test-Null {
	param(
		[Parameter(ValueFromPipeline = $true)]$InputObject,

		[ValidateSet("Null", "NullOrEmpty", "NullOrWhiteSpace")]
		[Parameter(Mandatory = $true, Position = 0)]
		$Type,

		[switch]$Not,
		[switch]$Bool
	)
	
	PROCESS {
		$InputObject | foreach {
			$current = $_
			
			$shouldSkip = switch ($Type) {
				"Null" { $null -eq $current }
				"NullOrEmpty" { [string]::IsNullOrEmpty($current) }
				"NullOrWhiteSpace" { [string]::IsNullOrWhiteSpace($current) }
			}
			
			if (-not $Not) { $shouldSkip = -not $shouldSkip }

			if ($Bool) { return (-not $shouldSkip) }
			
			if ($shouldSkip) { continue }
			else { return $current }
		}
	}
}