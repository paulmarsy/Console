$ProfileConfig.Temp.ModuleExports = @{
	Functions = @()
	Aliases = @()
}

$exportExclusionPattern = "_*"

$referenceFunctions =  Get-ChildItem Function:
$functions = Get-ChildItem (Join-Path $PSScriptRoot "..\..\Exports\Functions") -Filter *.ps1 -Recurse | Sort-Object -Property FullName
$functions | % { . $_.FullName }
$differenceFunctions =  Get-ChildItem Function:
Compare-Object -ReferenceObject $referenceFunctions -DifferenceObject $differenceFunctions | Select-Object -ExpandProperty InputObject | ? { $_.Name -notlike $exportExclusionPattern -and $ExecutionContext.SessionState.Module.Name -eq $_.Module.Name } | % {
	$ProfileConfig.Temp.ModuleExports.Functions += $_.Name
} 

$referenceAliases = Get-ChildItem Alias:
$aliases = Get-ChildItem (Join-Path $PSScriptRoot "..\..\Exports\Aliases") -Filter *.ps1 -Recurse | Sort-Object -Property FullName
$aliases | % { . $_.FullName }
$differenceAliases = Get-ChildItem Alias:
Compare-Object -ReferenceObject $referenceAliases -DifferenceObject $differenceAliases | Select-Object -ExpandProperty InputObject | ? { $_.Name -notlike $exportExclusionPattern -and $ExecutionContext.SessionState.Module.Name -eq $_.Module.Name } | % {
	$ProfileConfig.Temp.ModuleExports.Aliases += $_.Name
}