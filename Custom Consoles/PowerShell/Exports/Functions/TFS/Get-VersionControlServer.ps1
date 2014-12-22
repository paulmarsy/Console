function Get-VersionControlServer {
	[CmdletBinding()]
	param
	(
		$tfsServerUrl = $ProfileConfig.TFS.Server
	)

    $tpcFactory = _Get-TfsTpcFactory $tfsServerUrl
    $versionControlServer = $tpcFactory.GetService([type]"Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer")
	
	return $versionControlServer
}