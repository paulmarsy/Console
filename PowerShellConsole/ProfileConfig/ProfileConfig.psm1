param($InstallPath)

. (Join-Path $InstallPath "PowerShellConsole\Exports\Functions\Invoke-Ternary.ps1")
. (Join-Path $InstallPath "PowerShellConsole\Exports\Aliases\U+003F`&U+003A.ps1")

$PowerShellConsoleConstants = & (Join-Path $InstallPath "Common\Constants.ps1")
$ProfileConfigFile = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "ProfileConfig.json"

Get-ChildItem $PSScriptRoot -Filter *.ps1 | % { . $_.FullName }

Initialize-ProfileConfig

Export-ModuleMember -Function @("Reset-ProfileConfig", "Get-ProtectedProfileConfigSetting", "Set-ProtectedProfileConfigSetting")