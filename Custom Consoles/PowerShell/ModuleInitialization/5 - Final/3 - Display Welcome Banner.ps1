param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

$machineIpProperties = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()

Write-Host
Write-Host -NoNewline -ForegroundColor DarkGreen ([Environment]::UserDomainName)
Write-Host -NoNewline -ForegroundColor Gray "\"
Write-Host -NoNewline -ForegroundColor Green ([Environment]::UserName)
Write-Host -NoNewline -ForegroundColor Gray " on "
Write-Host -NoNewline -ForegroundColor Red $machineIpProperties.HostName
if (-not [string]::IsNullOrWhiteSpace($machineIpProperties.DomainName)) {
    Write-Host -NoNewline -ForegroundColor Red ".$($machineIpProperties.DomainName)"
}

Write-Host