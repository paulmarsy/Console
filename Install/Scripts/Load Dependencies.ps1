New-Variable -Scope Global -Name MessageScope -Value 0
New-Variable -Scope Global -Name InstallPath -Value (Resolve-Path (Join-Path $PSScriptRoot '..\..\'))
if ([System.Environment]::Is64BitProcess) { New-Variable -Scope Global -Name ProcessArchitecture -Value "64bit" }
else { New-Variable -Scope Global -Name ProcessArchitecture -Value "32bit" }
New-Variable -Scope Global -Name PowerShellConsoleUserFolder -Value (Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "PowerShell Console")
New-Variable -Scope Global -Name PowerShellConsoleAppSettingsFolder -Value (Join-Path $PowerShellConsoleUserFolder "App Settings")
New-Variable -Scope Global -Name PowerShellConsoleAppSettingsFunctionsFolder -Value (Join-Path $PowerShellConsoleAppSettingsFolder "Functions")
New-Variable -Scope Global -Name PowerShellConsoleUserScriptsFolder -Value (Join-Path $PowerShellConsoleUserFolder "User Scripts")
New-Variable -Scope Global -Name PowerShellConsoleTempFolder -Value (Join-Path $PowerShellConsoleUserFolder "Temp")
New-Variable -Scope Global -Name PowerShellConsoleVersion -Value (Get-Content -Path "..\Version.semver")
New-Variable -Scope Global -Name PowerShellConsoleVersionFile -Value (Join-Path $PowerShellConsoleAppSettingsFolder "Version.semver")

New-Variable -Scope Global -Name ConEmuExecutablePath -Value (Join-Path $InstallPath "Third Party\ConEmu\ConEmu64.exe")

if (Test-Path $PowerShellConsoleVersionFile) {
	New-Variable -Scope Global -Name InstalledPowerShellConsoleVersion -Value (Get-Content $PowerShellConsoleVersionFile)
} else {
	New-Variable -Scope Global -Name InstalledPowerShellConsoleVersion -Value "Not Installed"
}

Get-ChildItem ".\Install Helpers" -Filter *.ps1 | % { . $_.FullName }
. (Join-Path $InstallPath "PowerShellConsole\Exports\Functions\Invoke-Ternary.ps1")
. (Join-Path $InstallPath "PowerShellConsole\Exports\Aliases\U+003F`&U+003A.ps1")