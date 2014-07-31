# Microsoft Team Foundation Server 2013 Power Tools
if ($env:TFSPowerToolDir) {
	$tfsPowerTools = Join-Path $env:TFSPowerToolDir "Microsoft.TeamFoundation.PowerTools.PowerShell.dll"
	Import-Module $tfsPowerTools -Global
}