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
		[Hashtable]$ProcessParameters,
		[Parameter(ParameterSetName="Interactive")][ValidateSet("PerBuild", "AllBuilds")]$Wait,
		[Parameter(ParameterSetName="Interactive")][switch]$ContinueOnError,
		[Parameter(ParameterSetName="NonInteractive")][switch]$PassThru
	)

	BEGIN {
		function Complete-QueuedBuild {
			param($QueuedBuild, [ValidateSet("PerBuild", "AllBuilds")]$CompletionType)
			Write-Host -NoNewLine "Waiting for build '$($QueuedBuild.BuildDefinition.Name)' to finish... "

			$QueuedBuild.Connect()
			$QueuedBuild.Wait()
			$build = $QueuedBuild.Build
			$build.RefreshAllDetails()

			if ($build.Status -eq [Microsoft.TeamFoundation.Build.Client.BuildStatus]::Succeeded) {
				$colour = "Green"
				$shouldThrow = $false
			} else {
				$colour = "Red"
				if (-not $ContinueOnError) { $shouldThrow = $true }
				else { $shouldThrow = $false }
			}

			Write-Host -ForegroundColor $colour "$($build.Status). Started $($build.StartTime.ToLongTimeString()); Finished $($build.FinishTime.ToLongTimeString()); Duration $([Humanizer.TimeSpanHumanizeExtensions]::Humanize(([System.TimeSpan]::FromTicks($build.FinishTime.Ticks - $build.StartTime.Ticks)), 2))"

			if ($shouldThrow) {
				Exit-PipelineStats -Terminating
				throw "Halting build chain, ContinueOnError not specified, build drop location: $($build.DropLocation)"
			}
		}

		function Exit-PipelineStats {
			param ([switch]$Terminating)

			if ($PsCmdlet.ParameterSetName -eq "Interactive") {
				if ($Terminating) {
					$colour = "Magenta"
				} else {
					$colour = "Cyan"
					$QueuedBuilds | ? { $null -ne $_ } | % {
						Complete-QueuedBuild -QueuedBuild $_ -CompletionType AllBuilds
					}
				}
				$EndTime = Get-Date | % Ticks

				Write-Host -ForegroundColor $colour "Finished at $((New-Object -TypeName System.DateTime -ArgumentList $EndTime).ToLongTimeString()), total duration $([Humanizer.TimeSpanHumanizeExtensions]::Humanize(([System.TimeSpan]::FromTicks($EndTime - $StartTime)), 2))"
			}
		}

		if ($PsCmdlet.ParameterSetName -eq "Interactive") {
			$QueuedBuilds = @()

			Add-Type -Path (Join-Path $ProfileConfig.Module.InstallPath "Libraries\Misc\Humanizer.dll")
			$StartTime = Get-Date | % Ticks
			Write-Host -ForegroundColor Cyan "Starting builds at $((New-Object -TypeName System.DateTime -ArgumentList $StartTime).ToLongTimeString())..."
		}
	}

	PROCESS {
		$BuildDefinition | foreach {

			$currentBuildDefinition = $_
			$buildServer = $_.BuildServer

			$buildRequest = $currentBuildDefinition.CreateBuildRequest()

			if ($null -ne $ProcessParameters) {
				$workflowProcessProperties = [Microsoft.TeamFoundation.Build.Workflow.WorkflowHelpers]::DeserializeWorkflow($currentBuildDefinition.Process.Parameters) | % Properties | % Name
				$currentProcessParameters = [Microsoft.TeamFoundation.Build.Workflow.WorkflowHelpers]::DeserializeProcessParameters($buildRequest.ProcessParameters)
				$ProcessParameters.GetEnumerator() | ? { $workflowProcessProperties -contains $_.Key } | % {
					if ($currentProcessParameters.ContainsKey($_.Key)) {
						$currentProcessParameters.Remove($_.Key) | Out-Null
					}
					$currentProcessParameters.Add($_.Key, $_.Value)
				}
				$buildRequest.ProcessParameters = [Microsoft.TeamFoundation.Build.Workflow.WorkflowHelpers]::SerializeProcessParameters($currentProcessParameters)
			}

			$queuedBuild = $buildServer.QueueBuild($buildRequest)

			if ($PsCmdlet.ParameterSetName -eq "Interactive") {
				switch ($Wait)
				{
					"PerBuild" { Complete-QueuedBuild -QueuedBuild $queuedBuild -CompletionType PerBuild }
					"AllBuilds" { Write-Host "Starting build '$($currentBuildDefinition.Name)'"; $QueuedBuilds += $queuedBuild }
				}
			} else {
				if ($PassThru) { return $currentBuildDefinition }
				else { return $currentBuildDefinition.Uri.ToString() }
			}
		}
	}

	END {
		Exit-PipelineStats
	}
}
