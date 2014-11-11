Set-StrictMode -Version Latest

$ConsoleRoot = Resolve-Path -Path (Join-Path $PSScriptRoot "..\") | % Path

Get-ChildItem (Join-Path $PSScriptRoot "ModuleInitialization") -Filter *.ps1 -Recurse | Sort-Object FullName | % { . $_.FullName }

& (Join-Path $PSScriptRoot "Module Destructor.ps1")

Export-ModuleMember -Function $ProfileConfig.Temp.ModuleExports.Functions -Alias $ProfileConfig.Temp.ModuleExports.Aliases

Write-Host
Write-Host -ForegroundColor Green "PowerShell Console Module successfully loaded"
Write-Host -ForegroundColor DarkGreen "`t Use 'Show-PowerShellConsoleHelp' for a list of available commands"