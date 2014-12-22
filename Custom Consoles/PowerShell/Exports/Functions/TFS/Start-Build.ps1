function Start-Build {
	[CmdletBinding(DefaultParameterSetName="Default")]
	param
	(
		[Parameter(ParameterSetName="Default")]
		[Parameter(ParameterSetName="Interactive")]
		[Parameter(ParameterSetName="NonInteractive")]
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]$BuildDefinition,
		[Parameter(ParameterSetName="Interactive", Mandatory = $true)][switch]$Wait,
		[Parameter(ParameterSetName="Interactive")][switch]$ContinueOnError,
		[Parameter(ParameterSetName="NonInteractive")][switch]$PassThru
	)

	PROCESS {
		$BuildDefinition | foreach {
			$queuedBuild = $_.BuildServer.QueueBuild($_)

			if ($PsCmdlet.ParameterSetName -eq "Interactive") {
				Write-Host -NoNewLine "Starting build '$($_.Name)'... "

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
				if ($PassThru) { return $_ }
				else { return $_.Uri.ToString() }
			}
		}
	}
}