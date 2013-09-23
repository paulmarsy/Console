function Initialize-ProfileConfig {
    if (Test-Path $profileConfigFile) {
        $importedProfileConfig = Import-Clixml $profileConfigFile
    }

    $ProfileConfig = New-ProfileConfig $importedProfileConfig

    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
        $ProfileConfig | Export-Clixml $ProfileConfig.General.ProfileConfigFile
    }

    $ExecutionContext.SessionState.Module.OnRemove = {
        $ProfileConfig | Export-Clixml $profileConfigFile
    }

    $ProfileConfig
}