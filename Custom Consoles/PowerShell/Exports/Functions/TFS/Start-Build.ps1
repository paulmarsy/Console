function Start-Build {
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]$BuildDefinition
	)

	PROCESS {
		$BuildDefinition | foreach {
			$_.BuildServer.QueueBuild($_)
		}
	}
}