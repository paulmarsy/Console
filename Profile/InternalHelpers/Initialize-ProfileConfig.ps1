function Initialize-ProfileConfig {
    if (Test-Path $profileConfigFile) {
        $importedProfileConfig = Import-Clixml $profileConfigFile
    }

    $ProfileConfig = New-ProfileConfig $importedProfileConfig

    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
        Export-ProfileConfig
    }

    $ExecutionContext.SessionState.Module.OnRemove = {
        Export-ProfileConfig
    }

    $ProfileConfig
}