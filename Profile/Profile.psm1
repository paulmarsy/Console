param($InstallPath)




Import-Module (Join-Path $PSScriptRoot InternalHelpers)
Import-Module (Join-Path $PSScriptRoot ProfileConfig) -ArgumentList $InstallPath 
$global:t = get-module

#Get-ChildItem "$PSScriptRoot\", "$PSScriptRoot\Configure", "$PSScriptRoot\ExportedModuleMembers" -Filter *.ps1 | Sort-Object DirectoryName, Name | % { . $_.FullName -InstallPath $InstallPath -ConsoleConfig $Global:ConsoleConfig }

#$includeFile = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "include.ps1"
#if (Test-Path $includeFile) {
#    Write-Host "Loading include file $includeFile..."
#    . $includeFile -ConsoleConfig $Global:ConsoleConfig
#}

Export-ModuleMember -Function * -Alias * -Cmdlet * -Variable ProfileConfig