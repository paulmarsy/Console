Set-StrictMode -Version Latest

$InstallPath = Get-Item -Path Env:\CustomConsolesInstallPath | % Value

. (Join-Path $InstallPath "Config\Core-Functionality.ps1") -InstallPath $InstallPath

$script:ProfileConfigFile = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "ProfileConfig.json"

Get-ChildItem $PSScriptRoot -Filter *.ps1 -Recurse -File | % { . $_.FullName }

Initialize-ProfileConfig

Export-ModuleMember -Function @(
	"Get-ProfileConfig"
	"Save-ProfileConfig"
	"Get-ProtectedProfileConfigSetting"
	"Set-ProtectedProfileConfigSetting"
	"Test-ProtectedProfileConfigSetting"
)
