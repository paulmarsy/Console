function Get-TfsTeamProjects {
	Get-VersionControlServer | % { $_.GetAllTeamProjects($true) } | % { $_.Name }
}