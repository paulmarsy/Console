param($InstallPath)
Set-StrictMode -Version Latest

Import-Module (Join-Path $PSScriptRoot ProfileConfig) -ArgumentList $InstallPath
Export-ModuleMember -Variable ProfileConfig

Get-ChildItem "$PSScriptRoot\ModuleInitialization" -Filter *.ps1 -Recurse | Sort-Object Name | % { & $_.FullName }

Export-ModuleMember -Function (Get-ChildItem "$PSScriptRoot\Exports\Functions" -Filter *.ps1 -Recurse | % { . $_.FullName; $_.BaseName })
Export-ModuleMember -Alias (Get-ChildItem "$PSScriptRoot\Exports\Aliases" -Filter *.ps1 -Recurse | % { . $_.FullName; $_.BaseName })

$includeFile = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "PowerShell Scripts\include.ps1"
if ((Test-Path $includeFile) -and -not ([String]::IsNullOrWhiteSpace([IO.File]::ReadAllText($includeFile)))) {
    Write-Host "Loading include file $includeFile..."
    $referenceFunctions =  Get-ChildItem function: | Select-Object -ExpandProperty Name
    $referenceAliases = Get-ChildItem alias: | Select-Object -ExpandProperty Name
    . $includeFile
    $differenceFunctions =  Get-ChildItem function: | Select-Object -ExpandProperty Name
    $differenceAliases = Get-ChildItem alias: | Select-Object -ExpandProperty Name

    $includedFunctions = Compare-Object -ReferenceObject $referenceFunctions -DifferenceObject $differenceFunctions | Select-Object -ExpandProperty InputObject
    $includedFunctions | ? { $_ -notlike "_*" -and (Get-Command $_).ModuleName -eq "Profile" } | % { Write-Host "Importing function $_..."; Export-ModuleMember -Function $_ } 
    $includedAliases = Compare-Object -ReferenceObject $referenceAliases -DifferenceObject $differenceAliases | Select-Object -ExpandProperty InputObject
    $includedAliases | ? { $_ -notlike "_*" -and (Get-Command $_).ModuleName -eq "Profile" } |  % { Write-Host "Importing alias $_...";  Export-ModuleMember -Alias $_ }
}