function Get-BuildServer {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)]$tfsServerUrl = $Global:ConsoleConfig.TFS.Server
	)
	
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client") | Out-Null
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client") | Out-Null
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Workflow") | Out-Null

    $tpcFactory = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($tfsServerUrl)
    $tpcFactory.EnsureAuthenticated()
	$buildServer = $tpcFactory.GetService([type]"Microsoft.TeamFoundation.Build.Client.IBuildServer")
	
	return $buildServer
}

function Get-TFSProject {
	or able to enumeate from build server?
	# look up value in user's custom config system which should be in my docs or somewhere private
}