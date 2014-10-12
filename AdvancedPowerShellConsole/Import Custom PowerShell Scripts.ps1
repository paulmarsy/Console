param($ExportExclusionPattern)

$includeFile = $ProfileConfig.General.ProfileHookFile
if ((Test-Path $includeFile) -and -not ([String]::IsNullOrWhiteSpace([IO.File]::ReadAllText($includeFile)))) {
	Write-Host

    Write-Host "Loading include file $includeFile..."
    $referenceFunctions =  Get-ChildItem function: | Select-Object -ExpandProperty Name
    $referenceAliases = Get-ChildItem alias: | Select-Object -ExpandProperty Name
    try {
        Push-Location $ProfileConfig.General.PowerShellScriptsFolder
        . $includeFile
    }
    finally {
        Pop-Location
    }
    $differenceFunctions =  Get-ChildItem function: | Select-Object -ExpandProperty Name
    $differenceAliases = Get-ChildItem alias: | Select-Object -ExpandProperty Name

    $includedFunctions = Compare-Object -ReferenceObject $referenceFunctions -DifferenceObject $differenceFunctions | Select-Object -ExpandProperty InputObject
    $includedFunctions | ? { $_ -notlike $ExportExclusionPattern -and (Get-Command $_).ModuleName -eq "AdvancedPowerShellConsole" } | % { Write-Host "Importing function $_..."; Export-ModuleMember -Function $_ } 
    $includedAliases = Compare-Object -ReferenceObject $referenceAliases -DifferenceObject $differenceAliases | Select-Object -ExpandProperty InputObject
    $includedAliases | ? { $_ -notlike $ExportExclusionPattern -and (Get-Command $_).ModuleName -eq "AdvancedPowerShellConsole" } |  % { Write-Host "Importing alias $_...";  Export-ModuleMember -Alias $_ }

    Write-Host
}