if (Test-Path Env:TFSPowerToolDir) {
	$tfsPowerTools = Join-Path $env:TFSPowerToolDir "Microsoft.TeamFoundation.PowerTools.PowerShell.dll"
	Import-Module $tfsPowerTools -Global
} else {
	Write-Warning "Unable to import the soft Team Foundation Server 2013 Power Tools module"
}