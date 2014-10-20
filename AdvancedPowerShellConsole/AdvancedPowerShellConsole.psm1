param($InstallPath)

Set-StrictMode -Version Latest

Get-ChildItem (Join-Path $PSScriptRoot "ModuleInitialization") -Filter *.ps1 -Recurse | Sort-Object FullName | % { . $_.FullName }

Export-ModuleMember -Function $ProfileConfig.Module.ExportedFunctions -Alias $ProfileConfig.Module.ExportedAliases

Write-Host -ForegroundColor Green "Advanced PowerShell Console Module successfully loaded"