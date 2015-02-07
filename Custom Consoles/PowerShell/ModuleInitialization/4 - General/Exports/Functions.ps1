param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $true}) }

$exportExclusionPattern = "_*"

$referenceFunctions =  Get-ChildItem Function:
Get-ChildItem (Join-Path $ProfileConfig.ConsolePaths.PowerShell "Exports\Functions") -Filter *.ps1 -Recurse -File | Sort-Object -Property FullName | % { . $_.FullName }
$differenceFunctions =  Get-ChildItem Function:
Compare-Object -ReferenceObject $referenceFunctions -DifferenceObject $differenceFunctions -Property @("Name", "ModuleName") | ? { $_.Name -notlike $exportExclusionPattern -and $ExecutionContext.SessionState.Module.Name -eq $_.ModuleName } | % {
	Export-ModuleMember -Function $_.Name
}
