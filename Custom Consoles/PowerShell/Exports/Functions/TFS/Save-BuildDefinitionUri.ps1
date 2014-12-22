function Save-BuildDefinitionUri {
	param
	(
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]$BuildDefinition,
		[Parameter(Mandatory = $true)]$File
	)

	PROCESS {
		$BuildDefinition | foreach {
			$_ | % Uri | % ToString | Add-Content -Path $File -Encoding UTF8
		}
	}
}