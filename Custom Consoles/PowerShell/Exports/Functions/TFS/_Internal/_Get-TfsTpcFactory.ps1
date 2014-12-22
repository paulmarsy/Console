function _Get-TfsTpcFactory {
	param
	(
		$tfsServerUrl = $ProfileConfig.TFS.Server
	)

	if ($tfsServerUrl -eq $null) {
		throw "No TFS Server URL Given"
	}
	
	_Import-TfsAssemblies

    $tpcFactory = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($tfsServerUrl)
    $tpcFactory.EnsureAuthenticated()

    return $tpcFactory
}