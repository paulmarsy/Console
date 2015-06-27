function _Get-TfsTpcFactory {
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')] 
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