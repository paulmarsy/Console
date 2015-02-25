function Copy-BuildDefinition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]$Prefix,
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]$BuildDefinition,
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]$TeamProject,
        [scriptblock]$NameTransformation = {
            param($Name)
            
            return ("{0}-{1}" -f $Prefix, $Name)
        },
        [Hashtable]$ProcessParameters
    )
    
    BEGIN {
        $buildServer = Get-BuildServer
    }

    PROCESS {
        $BuildDefinition | % {
            $newBuildDefinition = $buildServer.CreateBuildDefinition($TeamProject)
            $newBuildDefinition.CopyFrom($_)
            $newBuildDefinition.Name = $NameTransformation.InvokeReturnAsIs($_.Name)
            $newBuildDefinition.Description = "Build cloned from '{0}' (ID: {1}) on {2} by {3}\{4}" -f $_.Name, `
                                                                                                       $_.Id, `
                                                                                                       (Get-Date -DisplayHint DateTime), `
                                                                                                       ([Environment]::UserDomainName), `
                                                                                                       ([Environment]::UserName)

            
            if ($null -ne $ProcessParameters) {
				$workflowProcessProperties = [Microsoft.TeamFoundation.Build.Workflow.WorkflowHelpers]::DeserializeWorkflow($newBuildDefinition.Process.Parameters) | % Properties | % Name
				$currentProcessParameters = [Microsoft.TeamFoundation.Build.Workflow.WorkflowHelpers]::DeserializeProcessParameters($newBuildDefinition.ProcessParameters)
				$ProcessParameters.GetEnumerator() | ? { $workflowProcessProperties -contains $_.Key } | % {
					if ($currentProcessParameters.ContainsKey($_.Key)) {
						$currentProcessParameters.Remove($_.Key)
					}
					$currentProcessParameters.Add($_.Key, $_.Value)
				}
				$newBuildDefinition.ProcessParameters = [Microsoft.TeamFoundation.Build.Workflow.WorkflowHelpers]::SerializeProcessParameters($currentProcessParameters)
			}
            $newBuildDefinition.Save()
            
            $newBuildDefinition | Write-Output
        }
    }
}