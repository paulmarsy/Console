$consoleConfigFile = Join-Path (Split-Path $PROFILE.CurrentUserAllHosts -Parent) "ConsoleConfig.xml"

if (Test-Path $consoleConfigFile) {
    $importedConsoleConfig = Import-Clixml $consoleConfigFile
}

. $PSScriptRoot\ExportedModuleMembers\New-ConsoleConfig.ps1
$Global:ConsoleConfig = New-ConsoleConfig $importedConsoleConfig

Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
    Export-ConsoleConfig
}