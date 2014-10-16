New-Variable -Scope Global -Name MessageScope -Value 0
New-Variable -Scope Global -Name InstallPath -Value (Resolve-Path (Join-Path $PSScriptRoot '..\..\'))
if ([System.Environment]::Is64BitProcess) { New-Variable -Scope Global -Name ProcessArchitecture -Value "64bit" }
else { New-Variable -Scope Global -Name ProcessArchitecture -Value "32bit" }
New-Variable -Scope Global -Name AdvancedPowerShellConsoleUserFolder -Value (Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "Advanced PowerShell Console")
New-Variable -Scope Global -Name AdvancedPowerShellConsoleAppSettingsFolder -Value (Join-Path $AdvancedPowerShellConsoleUserFolder "App Settings")
New-Variable -Scope Global -Name AdvancedPowerShellConsoleAppSettingsFunctionsFolder -Value (Join-Path $AdvancedPowerShellConsoleAppSettingsFolder "Functions")
New-Variable -Scope Global -Name AdvancedPowerShellConsoleUserScriptsFolder -Value (Join-Path $AdvancedPowerShellConsoleUserFolder "User Scripts")
New-Variable -Scope Global -Name AdvancedPowerShellConsoleTempFolder -Value (Join-Path $AdvancedPowerShellConsoleUserFolder "Temp")
New-Variable -Scope Global -Name AdvancedPowerShellConsoleVersion -Value (Get-Content -Path "..\Version.semver")
New-Variable -Scope Global -Name AdvancedPowerShellConsoleVersionFile -Value (Join-Path $AdvancedPowerShellConsoleAppSettingsFolder "Version.semver")

New-Variable -Scope Global -Name ConEmuExecutablePath -Value (Join-Path $InstallPath "Third Party\Console\ConEmu64.exe")

if (Test-Path $AdvancedPowerShellConsoleVersionFile) {
	New-Variable -Scope Global -Name InstalledAdvancedPowerShellConsoleVersion -Value (Get-Content $AdvancedPowerShellConsoleVersionFile)
} else {
	New-Variable -Scope Global -Name InstalledAdvancedPowerShellConsoleVersion -Value "Not Installed"
}

Get-ChildItem ".\Install Helpers" -Filter *.ps1 | % { . $_.FullName }
. (Join-Path $InstallPath "AdvancedPowerShellConsole\Exports\Functions\Invoke-Ternary.ps1")
. (Join-Path $InstallPath "AdvancedPowerShellConsole\Exports\Aliases\U+003F`&U+003A.ps1")