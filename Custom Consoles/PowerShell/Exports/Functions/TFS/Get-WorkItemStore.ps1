function Get-WorkItemStore {
	param
	(
		$TfsServerUrl = $ProfileConfig.TFS.Server
	)

    $tpcFactory = _Get-TfsTpcFactory $TfsServerUrl
    $workItemStore = $tpcFactory.GetService([type]"Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItemStore")
	
	return $workItemStore
}