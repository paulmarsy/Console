param($InstallPath)

Set-StrictMode -Version Latest

$machineIpProperties = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()
Write-Host -NoNewline "`t"
Write-Host -NoNewline -ForegroundColor Cyan ([Environment]::UserDomainName)
Write-Host -NoNewline -ForegroundColor Gray "\"
Write-Host -NoNewline -ForegroundColor Green ([Environment]::UserName)
Write-Host -NoNewline -ForegroundColor Gray " on "
Write-Host -NoNewline -ForegroundColor Red $machineIpProperties.HostName
if (-not [string]::IsNullOrWhiteSpace($machineIpProperties.DomainName)) {
    Write-Host -NoNewline -ForegroundColor Red ".$($machineIpProperties.DomainName)"
}
Write-Host ([Environment]::NewLine)

Import-Module (Join-Path $PSScriptRoot "ProfileConfig") -ArgumentList $InstallPath -Global

Get-ChildItem (Join-Path $PSScriptRoot "ModuleInitialization") -Filter *.ps1 -Recurse | Sort-Object FullName | % { & $_.FullName }

$functions = Get-ChildItem (Join-Path $PSScriptRoot "Exports\Functions") -Filter *.ps1 -Recurse
$aliases = Get-ChildItem (Join-Path $PSScriptRoot "Exports\Aliases") -Filter *.ps1 -Recurse

$functions + $aliases | % { . $_.FullName }

if (Assert-ConsoleIsInSync) {
	Sync-ConsoleWithGitHub -DontPushToGitHub -UpdateConsole Auto
}

$exportExclusionPattern = "_*.ps1"

Export-ModuleMember -Function ($functions | ? { $_ -notlike $exportExclusionPattern } | % { $_.BaseName })
Export-ModuleMember -Alias  ($aliases | ? { $_ -notlike $exportExclusionPattern } | % { $_.BaseName })

& (Join-Path $PSScriptRoot "Import Custom PowerShell Scripts.ps1") -ExportExclusionPattern $exportExclusionPattern

Write-Host -ForegroundColor Green "Advanced PowerShell Console Module successfully loaded"