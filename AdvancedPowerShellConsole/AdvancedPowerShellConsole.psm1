param($InstallPath)
Set-StrictMode -Version Latest

Import-Module (Join-Path $PSScriptRoot ProfileConfig) -ArgumentList $InstallPath
Export-ModuleMember -Variable ProfileConfig

Get-ChildItem "$PSScriptRoot\ModuleInitialization" -Filter *.ps1 -Recurse | Sort-Object FullName | % { & $_.FullName }

Export-ModuleMember -Function (Get-ChildItem "$PSScriptRoot\Exports\Functions" -Filter *.ps1 -Recurse | % { . $_.FullName; $_.BaseName })
Export-ModuleMember -Alias (Get-ChildItem "$PSScriptRoot\Exports\Aliases" -Filter *.ps1 -Recurse | % { . $_.FullName; $_.BaseName })

$powerShellScriptsFolder = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "PowerShell Scripts"
$includeFile = Join-Path $powerShellScriptsFolder "include.ps1"
if ((Test-Path $includeFile) -and -not ([String]::IsNullOrWhiteSpace([IO.File]::ReadAllText($includeFile)))) {
    Write-Host "Loading include file $includeFile..."
    $referenceFunctions =  Get-ChildItem function: | Select-Object -ExpandProperty Name
    $referenceAliases = Get-ChildItem alias: | Select-Object -ExpandProperty Name
    try {
        Push-Location $powerShellScriptsFolder
        . $includeFile
    }
    finally {
        Pop-Location
    }
    $differenceFunctions =  Get-ChildItem function: | Select-Object -ExpandProperty Name
    $differenceAliases = Get-ChildItem alias: | Select-Object -ExpandProperty Name

    $includedFunctions = Compare-Object -ReferenceObject $referenceFunctions -DifferenceObject $differenceFunctions | Select-Object -ExpandProperty InputObject
    $includedFunctions | ? { $_ -notlike "_*" -and (Get-Command $_).ModuleName -eq "AdvancedPowerShellConsole" } | % { Write-Host "Importing function $_..."; Export-ModuleMember -Function $_ } 
    $includedAliases = Compare-Object -ReferenceObject $referenceAliases -DifferenceObject $differenceAliases | Select-Object -ExpandProperty InputObject
    $includedAliases | ? { $_ -notlike "_*" -and (Get-Command $_).ModuleName -eq "AdvancedPowerShellConsole" } |  % { Write-Host "Importing alias $_...";  Export-ModuleMember -Alias $_ }
}

Write-Host -ForegroundColor Green "PowerShell Console Module was successfully loaded."