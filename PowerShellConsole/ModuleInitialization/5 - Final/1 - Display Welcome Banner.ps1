$machineIpProperties = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()
$networkConnectionProfile = Get-NetConnectionProfile

Write-Host
Write-Host -NoNewline -ForegroundColor DarkGreen ([Environment]::UserDomainName)
Write-Host -NoNewline -ForegroundColor Gray "\"
Write-Host -NoNewline -ForegroundColor Green ([Environment]::UserName)
Write-Host -NoNewline -ForegroundColor Gray " on "
Write-Host -NoNewline -ForegroundColor Red $machineIpProperties.HostName
if (-not [string]::IsNullOrWhiteSpace($machineIpProperties.DomainName)) {
    Write-Host -NoNewline -ForegroundColor Red ".$($machineIpProperties.DomainName)"
}
if (Test-NetworkStatus) {
	Write-Host -NoNewline -ForegroundColor Gray " ("
	Write-Host -NoNewline -ForegroundColor DarkGreen $networkConnectionProfile.NetworkCategory
	Write-Host -NoNewline -ForegroundColor Gray ")"
}

Write-Host

if (Test-NetworkStatus) {
	Write-Host -NoNewline "Connected to network '"
	Write-Host -NoNewline -ForegroundColor DarkGreen $networkConnectionProfile.Name
	Write-Host -NoNewline "' over "
	Write-Host -ForegroundColor Yellow $networkConnectionProfile.InterfaceAlias
	Write-Host "IPv4 Connectivity: $($networkConnectionProfile.IPv4Connectivity)"
	Write-Host "IPv6 Connectivity: $($networkConnectionProfile.IPv6Connectivity)"
}

Write-Host