param($InstallPath)

. (Join-Path $InstallPath "AdvancedPowerShellConsole\Exports\Functions\Invoke-Ternary.ps1")
. (Join-Path $InstallPath "AdvancedPowerShellConsole\Exports\Aliases\U+003F`&U+003A.ps1")

$profileConfigFile = Join-Path (Split-Path $PROFILE.CurrentUserAllHosts) "ProfileConfig.xml"

Get-ChildItem $PSScriptRoot -Filter *.ps1 | % { . $_.FullName }

Initialize-ProfileConfig

Export-ModuleMember -Function @("Sync-ProfileConfig", "Get-ProtectedProfileConfigSetting", "Set-ProtectedProfileConfigSetting")