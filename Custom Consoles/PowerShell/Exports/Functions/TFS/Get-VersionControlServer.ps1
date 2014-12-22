function Get-VersionControlServer {
	param
	(
		$TfsServerUrl = $ProfileConfig.TFS.Server
	)

    $tpcFactory = _Get-TfsTpcFactory $TfsServerUrl
    $versionControlServer = $tpcFactory.GetService([type]"Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer")
	
	return $versionControlServer
}