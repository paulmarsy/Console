Set-StrictMode -Version Latest

$ConsoleRoot = Resolve-Path -Path (Join-Path $PSScriptRoot "..\") | % Path

. (Join-Path $ConsoleRoot "PowerShellConsole\Exports\Functions\Invoke-Ternary.ps1")
. (Join-Path $ConsoleRoot "PowerShellConsole\Exports\Aliases\U+003F`&U+003A.ps1")

$PowerShellConsoleConstants = & (Join-Path $ConsoleRoot "Constants.ps1")
$ProfileConfigFile = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "ProfileConfig.json"

Get-ChildItem $PSScriptRoot -Filter *.ps1  -Recurse| % { . $_.FullName }

Initialize-ProfileConfig

Export-ModuleMember -Function @(
	"Get-ProfileConfig"
	"Save-ProfileConfig"
	"Get-ProtectedProfileConfigSetting"
	"Set-ProtectedProfileConfigSetting"
	"Test-ProtectedProfileConfigSetting"
)