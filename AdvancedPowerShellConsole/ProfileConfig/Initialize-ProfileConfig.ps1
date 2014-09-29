function Initialize-ProfileConfig {
    if (Test-Path $profileConfigFile) {
        $importedProfileConfig = Import-Clixml $profileConfigFile
    }

    $newProfileConfig = New-ProfileConfig -OverrideProfileConfig $importedProfileConfig

    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
         Get-Variable -Name ProfileConfig -ValueOnly -Scope Global | Export-Clixml $ProfileConfig.General.ProfileConfigFile
    }

    $ExecutionContext.SessionState.Module.OnRemove = {
        Get-Variable -Name ProfileConfig -ValueOnly -Scope Global | Export-Clixml $profileConfigFile
    }

    if (Test-Path Variable:Global:ProfileConfig) {
        Remove-Variable -Name ProfileConfig -Scope Global -Force
    }

    New-Variable -Name ProfileConfig -Description "Contains configuration global information for the Advanced PowerShell Console" -Value $newProfileConfig -Scope Global -Option Readonly
}