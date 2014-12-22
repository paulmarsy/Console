function Get-TfsTeamProjects {
	param
	(
		$TfsServerUrl = $ProfileConfig.TFS.Server
	)

	Get-VersionControlServer $TfsServerUrl | % GetAllTeamProjects $true | % Name
}