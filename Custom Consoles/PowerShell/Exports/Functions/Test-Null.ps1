function Test-Null {
	param(
		[Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]$InputObject,

		[ValidateSet("Null", "NullOrEmpty", "NullOrWhiteSpace")]
		[Parameter(Mandatory = $true, Position = 1)]
		$Type,

		[switch]$Not,
		[switch]$Bool
	)
	
	PROCESS {
		if ($null -eq $InputObject -and $Bool) {
			if ($Not) { return $false }
			else { return $true }
		}

		$InputObject | foreach {
			$current = $_
			
			$result = switch ($Type) {
				"Null" { $null -eq $current }
				"NullOrEmpty" { [string]::IsNullOrEmpty($current) }
				"NullOrWhiteSpace" { [string]::IsNullOrWhiteSpace($current) }
			}
			
			if (-not $Not) { $result = -not $result }

			if ($Bool) { return (-not $result) }
			
			if ($result) { continue }
			else { return $current }
		}
	}
}