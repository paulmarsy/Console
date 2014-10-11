param($InstallPath)

Set-StrictMode -Version Latest

$machineIpProperties = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()
$networkConnectionProfile = Get-NetConnectionProfile

Write-Host -NoNewline -ForegroundColor DarkGreen ([Environment]::UserDomainName)
Write-Host -NoNewline -ForegroundColor Gray "\"
Write-Host -NoNewline -ForegroundColor Green ([Environment]::UserName)
Write-Host -NoNewline -ForegroundColor Gray " on "
Write-Host -NoNewline -ForegroundColor Red $machineIpProperties.HostName
if (-not [string]::IsNullOrWhiteSpace($machineIpProperties.DomainName)) {
    Write-Host -NoNewline -ForegroundColor Red ".$($machineIpProperties.DomainName)"
}
Write-Host -NoNewline -ForegroundColor Gray " ("
Write-Host -NoNewline -ForegroundColor DarkGreen $networkConnectionProfile.NetworkCategory
Write-Host -NoNewline -ForegroundColor Gray ")"
Write-Host
Write-Host -NoNewline "Connected to network '"
Write-Host -NoNewline -ForegroundColor DarkGreen $networkConnectionProfile.Name
Write-Host -NoNewline "' over "
Write-Host -ForegroundColor Yellow $networkConnectionProfile.InterfaceAlias
Write-Host "IPv4 Connectivity: $($networkConnectionProfile.IPv4Connectivity)"
Write-Host "IPv6 Connectivity: $($networkConnectionProfile.IPv6Connectivity)"
Write-Host

Import-Module (Join-Path $PSScriptRoot "ProfileConfig") -ArgumentList $InstallPath -Global

Get-ChildItem (Join-Path $PSScriptRoot "ModuleInitialization") -Filter *.ps1 -Recurse | Sort-Object FullName | % { & $_.FullName }

$functions = Get-ChildItem (Join-Path $PSScriptRoot "Exports\Functions") -Filter *.ps1 -Recurse
$aliases = Get-ChildItem (Join-Path $PSScriptRoot "Exports\Aliases") -Filter *.ps1 -Recurse

$functions + $aliases | % { . $_.FullName }

if (Test-NetworkStatus) {
	if (Assert-ConsoleIsInSync) {
		Sync-ConsoleWithGitHub -DontPushToGitHub -UpdateConsole Auto
	} else {
		_updateGitHubCmdletParameters
	}
} else {
	Write-Host -ForegroundColor Red "Unable to synchronise with GitHub due to a lack of network connectivity"
}

$exportExclusionPattern = "_*.ps1"

Export-ModuleMember -Function ($functions | ? { $_ -notlike $exportExclusionPattern } | % { $_.BaseName })
Export-ModuleMember -Alias  ($aliases | ? { $_ -notlike $exportExclusionPattern } | % { $_.BaseName })

& (Join-Path $PSScriptRoot "Execute Startup Actions.ps1")

. (Join-Path $PSScriptRoot "Import Custom PowerShell Scripts.ps1") -ExportExclusionPattern $exportExclusionPattern

Write-Host -ForegroundColor Green "Advanced PowerShell Console Module successfully loaded"