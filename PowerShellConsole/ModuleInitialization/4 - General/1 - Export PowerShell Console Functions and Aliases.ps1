$ProfileConfig.Temp.ModuleExports = @{
	Functions = @()
	Aliases = @()
}

$exportExclusionPattern = "_*"

$referenceFunctions =  Get-ChildItem Function: 
Get-ChildItem (Join-Path $PSScriptRoot "..\..\Exports\Functions") -Filter *.ps1 -Recurse | Sort-Object -Property FullName | % { . $_.FullName }
$differenceFunctions =  Get-ChildItem Function:
Compare-Object -ReferenceObject $referenceFunctions -DifferenceObject $differenceFunctions -Property @("Name", "ModuleName") | ? { $_.Name -notlike $exportExclusionPattern -and $ExecutionContext.SessionState.Module.Name -eq $_.ModuleName } | % {
	$ProfileConfig.Temp.ModuleExports.Functions += $_.Name
} 

$referenceAliases = Get-ChildItem Alias:
Get-ChildItem (Join-Path $PSScriptRoot "..\..\Exports\Aliases") -Filter *.ps1 -Recurse | Sort-Object -Property FullName | % { . $_.FullName }
$differenceAliases = Get-ChildItem Alias:
Compare-Object -ReferenceObject $referenceAliases -DifferenceObject $differenceAliases -Property @("Name", "ReferencedCommand", "ModuleName") | ? { $_.Name -notlike $exportExclusionPattern -and $ExecutionContext.SessionState.Module.Name -eq $_.ModuleName } | % {
	$ProfileConfig.Temp.ModuleExports.Aliases += $_.Name
}