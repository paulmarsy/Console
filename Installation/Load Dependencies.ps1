New-Variable -Scope Global -Name MessageScope -Value 0
New-Variable -Scope Global -Name InsideInstallStep -Value $false

. (Join-Path $PSScriptRoot "..\Config\Core-Functionality.ps1") -InstallPath (Join-Path $PSScriptRoot "..\")

Get-ChildItem (Join-Path $PSScriptRoot "Helpers") -File -Filter *.ps1 | % { . $_.FullName }