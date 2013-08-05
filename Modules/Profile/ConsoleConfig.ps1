$consoleConfigFile = Join-Path (Split-Path $PROFILE.CurrentUserAllHosts -Parent) "ConsoleConfig.xml"

if (Test-Path $consoleConfigFile) {
    $Global:ConsoleConfig = Import-Clixml $consoleConfigFile
}
else {
    . $PSScriptRoot\ExportedModuleMembers\New-ConsoleConfig.ps1
    $Global:ConsoleConfig = New-ConsoleConfig
}

Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
    Export-ConsoleConfig
}