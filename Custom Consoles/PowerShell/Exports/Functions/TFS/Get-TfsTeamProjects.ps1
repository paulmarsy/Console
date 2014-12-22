function Get-TfsTeamProjects {
	Get-VersionControlServer | % GetAllTeamProjects $true | % Name
}