function Get-BuildServer {
	param
	(
		$TfsServerUrl = $ProfileConfig.TFS.Server
	)

    $tpcFactory = _Get-TfsTpcFactory $TfsServerUrl
	$buildServer = $tpcFactory.GetService([type]"Microsoft.TeamFoundation.Build.Client.IBuildServer")
	
	return $buildServer
}