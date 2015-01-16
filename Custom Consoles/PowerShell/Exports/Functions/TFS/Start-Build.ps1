function Start-Build {
	[CmdletBinding(DefaultParameterSetName="Default")]
	param
	(
		[Parameter(ParameterSetName="Default")]
		[Parameter(ParameterSetName="Interactive")]
		[Parameter(ParameterSetName="NonInteractive")]
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]$BuildDefinition,
		[Parameter(ParameterSetName="Default")]
		[Parameter(ParameterSetName="Interactive")]
		[Parameter(ParameterSetName="NonInteractive")]
		$ProcessParameters,
		[Parameter(ParameterSetName="Interactive", Mandatory = $true)][switch]$Wait,
		[Parameter(ParameterSetName="Interactive")][switch]$ContinueOnError,
		[Parameter(ParameterSetName="NonInteractive")][switch]$PassThru
	)

	PROCESS {
		$BuildDefinition | foreach {
			$currentBuildDefinition = $_

			$buildRequest = $currentBuildDefinition.BuildServer.CreateBuildRequest($currentBuildDefinition)

			if (-not ([string]::IsNullOrWhiteSpace($ProcessParameters))) {
				$workflowProcessProperties = [Microsoft.TeamFoundation.Build.Workflow.WorkflowHelpers]::DeserializeWorkflow($currentBuildDefinition.Process.Parameters).Properties
				$currentProcessParameters = [Microsoft.TeamFoundation.Build.Workflow.WorkflowHelpers]::DeserializeProcessParameters($buildRequest.ProcessParameters)
				$ProcessParameters.GetEnumerator() | ?| % {

					}
				$buildRequest.ProcessParameters = [Microsoft.TeamFoundation.Build.Workflow.WorkflowHelpers]::SerializeProcessParameters($currentProcessParameters)
			}

			$queuedBuild = $currentBuildDefinition.BuildServer.QueueBuild($buildRequest)

			if ($PsCmdlet.ParameterSetName -eq "Interactive") {
				Write-Host -NoNewLine "Starting build '$($currentBuildDefinition.Name)'... "

				$queuedBuild.Connect()
				$queuedBuild.Wait()

				if ($queuedBuild.Build.Status -eq [Microsoft.TeamFoundation.Build.Client.BuildStatus]::Succeeded) {
					Write-Host -ForegroundColor Green "$($queuedBuild.Build.Status)."
				} else {
					Write-Host -ForegroundColor Red "$($queuedBuild.Build.Status)."
					if (-not $ContinueOnError) {
						throw "Halting build chain, ContinueOnError not specified"
					}
				}
			} else {
				if ($PassThru) { return $currentBuildDefinition }
				else { return $currentBuildDefinition.Uri.ToString() }
			}
		}
	}
}
