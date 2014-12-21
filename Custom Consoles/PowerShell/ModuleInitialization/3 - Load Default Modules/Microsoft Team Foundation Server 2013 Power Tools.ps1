param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

if (Test-Path Env:TFSPowerToolDir) {
	$tfsPowerTools = Join-Path $env:TFSPowerToolDir "Microsoft.TeamFoundation.PowerTools.PowerShell.dll"
	Export-Module $tfsPowerTools
} else {
	Write-Warning "Unable to import the soft Team Foundation Server 2013 Power Tools module"
}