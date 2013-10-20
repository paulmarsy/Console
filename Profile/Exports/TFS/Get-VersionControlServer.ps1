function Get-VersionControlServer {
	[CmdletBinding()]
	param
	(
		$tfsServerUrl = $ProfileConfig.TFS.Server
	)
	
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client") | Out-Null
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client") | Out-Null
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Workflow") | Out-Null

    $tpc = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($tpcUrl)
    $tpc.EnsureAuthenticated()
	$versionControlServer = $tpc.GetService([type]"Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer")
	
	return $versionControlServer
}
@{Function = "Get-VersionControlServer"}