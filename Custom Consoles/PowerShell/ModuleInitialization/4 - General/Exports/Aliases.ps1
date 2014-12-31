param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $true}) }

$ProfileConfig.Temp.ExportedAliases = @()

$exportExclusionPattern = "_*"

$referenceAliases = Get-ChildItem Alias:
Get-ChildItem (Join-Path $ProfileConfig.ConsolePaths.PowerShell "Exports\Aliases") -Filter *.ps1 -Recurse -File | Sort-Object -Property FullName | % { . $_.FullName }
$differenceAliases = Get-ChildItem Alias:
Compare-Object -ReferenceObject $referenceAliases -DifferenceObject $differenceAliases -Property @("Name", "ReferencedCommand", "ModuleName") | ? { $_.Name -notlike $exportExclusionPattern -and $ExecutionContext.SessionState.Module.Name -eq $_.ModuleName } | % {
	Export-ModuleMember -Alias $_.Name
}