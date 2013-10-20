param($InstallPath)
Set-StrictMode -Version Latest

$profileConfigFile = Join-Path (Split-Path $PROFILE.CurrentUserAllHosts) "ProfileConfig.xml"

Get-ChildItem $PSScriptRoot -Filter *.ps1 | % { . $_.FullName }

$ProfileConfig = Initialize-ProfileConfig

Export-ModuleMember -Function * -Alias * -Cmdlet * -Variable ProfileConfig