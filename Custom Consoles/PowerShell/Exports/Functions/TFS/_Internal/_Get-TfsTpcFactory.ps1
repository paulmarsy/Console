function _Get-TfsTpcFactory {
	param
	(
		$TfsServerUrl = $ProfileConfig.TFS.Server
	)

	if ($null -eq $TfsServerUrl) {
		throw "No TFS Server URL Given"
	}
	
	_Import-TfsAssemblies

    $tpcFactory = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($TfsServerUrl)
    $tpcFactory.EnsureAuthenticated()

    return $tpcFactory
}