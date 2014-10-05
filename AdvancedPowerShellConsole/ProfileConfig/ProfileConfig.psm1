param($InstallPath)

$profileConfigFile = Join-Path (Split-Path $PROFILE.CurrentUserAllHosts) "ProfileConfig.xml"

Get-ChildItem $PSScriptRoot -Filter *.ps1 | % { . $_.FullName }

Initialize-ProfileConfig

Export-ModuleMember -Function @("Sync-ProfileConfig", "Get-ProtectedProfileConfigSetting", "Set-ProtectedProfileConfigSetting", "Get-RootProtectedProfileConfigSettings")