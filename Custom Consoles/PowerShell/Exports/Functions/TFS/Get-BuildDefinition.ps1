function Get-BuildDefinition {
	param
	(
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]$BuildDefinitionUri,
		$TfsServerUrl = $ProfileConfig.TFS.Server
	)

	BEGIN {
		$buildServer = Get-BuildServer $TfsServerUrl
	}

	PROCESS {
		$BuildDefinitionUri | foreach {
			$buildServer.GetBuildDefinition($_)
		}
	}
}