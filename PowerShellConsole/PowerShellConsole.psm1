param($InstallPath)

Set-StrictMode -Version Latest

Get-ChildItem (Join-Path $PSScriptRoot "ModuleInitialization") -Filter *.ps1 -Recurse | Sort-Object FullName | % { . $_.FullName }

Export-ModuleMember -Function $ProfileConfig.Temp.ModuleExports.Functions -Alias $ProfileConfig.Temp.ModuleExports.Aliases

Write-Host
Write-Host -ForegroundColor Green "PowerShell Console Module successfully loaded"
Write-Host -ForegroundColor DarkGreen "`t Use 'Show-PowerShellConsoleHelp' for a list of available commands"