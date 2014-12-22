function Get-BuildServer {
	[CmdletBinding()]
	param
	(
		$tfsServerUrl = $ProfileConfig.TFS.Server
	)

    $tpcFactory = _Get-TfsTpcFactory $tfsServerUrl
	$buildServer = $tpcFactory.GetService([type]"Microsoft.TeamFoundation.Build.Client.IBuildServer")
	
	return $buildServer
}