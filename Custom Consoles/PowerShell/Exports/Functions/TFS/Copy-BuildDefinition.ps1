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
        [Hashtable]$ProcessParameters,
        [switch]$PassThru,
        [switch]$Force
    )
    
    BEGIN {
        $BuildServer = Get-BuildServer
    }

    PROCESS {
        $BuildDefinition | % {
            $buildName = $NameTransformation.InvokeReturnAsIs($_.Name)
            $existingBuildDefinitions = $BuildServer.QueryBuildDefinitions($BuildServer.CreateBuildDefinitionSpec($TeamProject, $buildName)) | % Definitions
            if ($null -ne $existingBuildDefinitions) {
                if ($Force) {
                    $existingBuildDefinitions.QueryBuilds() | % Delete ([Microsoft.TeamFoundation.Build.Client.DeleteOptions]::All) | Out-Null
                    $existingBuildDefinitions | % Delete
                } else {
                    throw "Build definition '$buildName' exists in the $TeamProject team project, specify -Force to overwrite it"
                }
            }
            
            $newBuildDefinition = $BuildServer.CreateBuildDefinition($TeamProject)
            $newBuildDefinition.CopyFrom($_)
            $newBuildDefinition.Name = $buildName
            $newBuildDefinition.Description = "Build cloned from '{0}' (ID: {1}) on {2} by {3}\{4}`n`nCustomised Process Parameters:`n`n{5}" -f $_.Name, `
                                                                                                       $_.Id, `
                                                                                                       (Get-Date -DisplayHint DateTime), `
                                                                                                       ([Environment]::UserDomainName), `
                                                                                                       ([Environment]::UserName), `
                                                                                                       ($ProcessParameters | Format-Table | Out-String | % Trim)

            
            if ($null -ne $ProcessParameters) {
				$workflowProcessProperties = [Microsoft.TeamFoundation.Build.Workflow.WorkflowHelpers]::DeserializeWorkflow($newBuildDefinition.Process.Parameters) | % Properties | % Name
				$currentProcessParameters = [Microsoft.TeamFoundation.Build.Workflow.WorkflowHelpers]::DeserializeProcessParameters($newBuildDefinition.ProcessParameters)
				$ProcessParameters.GetEnumerator() | ? { $workflowProcessProperties -contains $_.Key } | % {
					if ($currentProcessParameters.ContainsKey($_.Key)) {
						$currentProcessParameters.Remove($_.Key) | Out-Null
					}
					$currentProcessParameters.Add($_.Key, $_.Value)
				}
				$newBuildDefinition.ProcessParameters = [Microsoft.TeamFoundation.Build.Workflow.WorkflowHelpers]::SerializeProcessParameters($currentProcessParameters)
			}
            $newBuildDefinition.Save()
            
            if ($PassThru) {
                $newBuildDefinition | Write-Output
            } else {
                $newBuildDefinition.Uri.ToString() | Write-Output
            }
        }
    }
}