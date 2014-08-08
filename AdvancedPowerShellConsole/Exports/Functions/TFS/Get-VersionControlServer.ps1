function Get-VersionControlServer {
	[CmdletBinding()]
	param
	(
		$tfsServerUrl = $ProfileConfig.TFS.Server
	)

	if ($tfsServerUrl -eq $null) {
		Write-Error "No TFS Server URL Given"
	}
	
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client") | Out-Null
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client") | Out-Null
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Workflow") | Out-Null
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.VersionControl.Client") | Out-Null

    $tpcFactory = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($tfsServerUrl)
    $tpcFactory.EnsureAuthenticated()
	$versionControlServer = $tpcFactory.GetService([type]"Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer")
	
	return $versionControlServer
}