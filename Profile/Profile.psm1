 param($InstallPath)
Set-StrictMode -Version Latest

Import-Module (Join-Path $PSScriptRoot InternalHelpers)

$expTest = {
	param($ht)
	if ($ht.Alias) { $global:t = $ht; Set-Alias $ht.Alias.Name $ht.Alias.ResolvedCommandName; Export-ModuleMember -Alias $ht.Alias.Name }
	if ($ht.Function) { echo "function"; Export-ModuleMember -Function $ht.Function }
	#if ($ht.Variable) { echo "variable"; Export-ModuleMember -Variable $ht.Variable }
}

Get-ChildItem "$PSScriptRoot\Configure" -Filter *.ps1 | Sort-Object Name | % { & $_.FullName } | % { & $expTest $_ }

Get-ChildItem "$PSScriptRoot\Exports" -Filter *.ps1 | Sort-Object DirectoryName, Name | % { & $_.FullName }

$includeFile = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "include.ps1"
if (Test-Path $includeFile) {
    Write-Host "Loading include file $includeFile..."
    & $includeFile
}

#export var ProfileConfig

Export-ModuleMember -Variable ProfileConfig