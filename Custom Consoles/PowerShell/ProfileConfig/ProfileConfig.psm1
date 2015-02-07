Set-StrictMode -Version Latest

$InstallPath = Get-Item -Path Env:\CustomConsolesInstallPath | % Value

. (Join-Path $InstallPath "Custom Consoles\PowerShell\Exports\Functions\Invoke-Ternary.ps1")
Set-Alias -Name "?:" -Value Invoke-Ternary -Force

$PowerShellConsoleConstants = & (Join-Path $InstallPath "Config\Constants.ps1")
$ProfileConfigFile = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "ProfileConfig.json"

Get-ChildItem $PSScriptRoot -Filter *.ps1  -Recurse -File | % { . $_.FullName }

Initialize-ProfileConfig

Export-ModuleMember -Function @(
	"Get-ProfileConfig"
	"Save-ProfileConfig"
	"Get-ProtectedProfileConfigSetting"
	"Set-ProtectedProfileConfigSetting"
	"Test-ProtectedProfileConfigSetting"
)
