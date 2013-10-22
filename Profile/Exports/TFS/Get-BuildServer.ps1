function Get-BuildServer {
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
	$buildServer = $tpcFactory.GetService([type]"Microsoft.TeamFoundation.Build.Client.IBuildServer")
	
	return $buildServer
}
@{Function = "Get-BuildServer"}