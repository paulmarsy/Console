$functions = Get-ChildItem (Join-Path $PSScriptRoot "..\..\Exports\Functions") -Filter *.ps1 -Recurse | Sort-Object -Property FullName
$functions | % { . $_.FullName }

$aliases = Get-ChildItem (Join-Path $PSScriptRoot "..\..\Exports\Aliases") -Filter *.ps1 -Recurse | Sort-Object -Property FullName
$aliases | % { . $_.FullName }

$exportExclusionPattern = "_*.ps1"

$ProfileConfig.General.Module = @{
	ExportedFunctions = ($functions | ? { $_ -notlike $exportExclusionPattern } | % BaseName)
	ExportedAliases = ($aliases | ? { $_ -notlike $exportExclusionPattern } | % BaseName)
}