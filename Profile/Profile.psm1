param($InstallPath)
Set-StrictMode -Version Latest

Import-Module (Join-Path $PSScriptRoot InternalHelpers)

$expTest = {
	param($function, $alias, $variable)
	if ($function) { Export-ModuleMember -Function $function }
	if ($alias) { Export-ModuleMember -Alias $alias }
	if ($variable) { Export-ModuleMember -Variable $variable }
}

Get-ChildItem "$PSScriptRoot\Configure" -Filter *.ps1 | Sort-Object Name | % { & $_.FullName }

Get-ChildItem "$PSScriptRoot\Exports" -Filter *.ps1 | Sort-Object DirectoryName, Name | % { & $_.FullName }

$includeFile = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "include.ps1"
if (Test-Path $includeFile) {
    Write-Host "Loading include file $includeFile..."
    & $includeFile
}

#export var ProfileConfig

Export-ModuleMember -Variable ProfileConfig