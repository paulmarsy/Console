param($InstallPath)

. (Join-Path $InstallPath "AdvancedPowerShellConsole\Exports\Functions\Invoke-Ternary.ps1")
. (Join-Path $InstallPath "AdvancedPowerShellConsole\Exports\Aliases\U+003F`&U+003A.ps1")

$AdvancedPowerShellConsoleUserFolder = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "Advanced PowerShell Console"
$AdvancedPowerShellConsoleAppSettingsFolder = Join-Path $AdvancedPowerShellConsoleUserFolder "App Settings"
$AdvancedPowerShellConsoleUserScriptsFolder = Join-Path $AdvancedPowerShellConsoleUserFolder "User Scripts"
$AdvancedPowerShellConsoleTempFolder = Join-Path $AdvancedPowerShellConsoleUserFolder "Temp"
$ProfileConfigFile = Join-Path $AdvancedPowerShellConsoleAppSettingsFolder "ProfileConfig.xml"

Get-ChildItem $PSScriptRoot -Filter *.ps1 | % { . $_.FullName }

Initialize-ProfileConfig

Export-ModuleMember -Function @("Sync-ProfileConfig", "Get-ProtectedProfileConfigSetting", "Set-ProtectedProfileConfigSetting")