param($BaseFolder)

Set-StrictMode -Version Latest

$InstallPath = Get-Item -Path Env:\CustomConsolesInstallPath | % Value

. (Join-Path $InstallPath "Custom Consoles\PowerShell\Exports\Functions\PowerShell Utilities\Test-PowerShellScriptSyntax.ps1")
. (Join-Path $InstallPath "Custom Consoles\PowerShell\Exports\Functions\PowerShell Utilities\Test-PowerShellDirectory.ps1")

Test-PowerShellDirectory -Directory $BaseFolder -Quiet -Exclude "CustomPowerShellConsole.psd1"