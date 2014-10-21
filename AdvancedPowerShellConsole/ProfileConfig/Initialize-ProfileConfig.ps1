function Initialize-ProfileConfig {
    if (Test-Path $profileConfigFile) {
        $importedProfileConfig = Import-Clixml $profileConfigFile
    }

    $newProfileConfig = New-ProfileConfig -OverrideProfileConfig $importedProfileConfig

    $eventJob = Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action {
        $config = Get-Variable -Name ProfileConfig -ValueOnly -Scope Global
        $config.Remove("Temp")
        $config | Export-Clixml $config.Module.ProfileConfigFile
    }

    $ExecutionContext.SessionState.Module.OnRemove = {
        $eventJob | Stop-Job -PassThru | Remove-Job

        $config = Get-Variable -Name ProfileConfig -ValueOnly -Scope Global
        $config.Remove("Temp")
        $config | Export-Clixml $config.Module.ProfileConfigFile
    }.GetNewClosure()

    if (Test-Path Variable:Global:ProfileConfig) {
        Remove-Variable -Name ProfileConfig -Scope Global -Force
    }

    New-Variable -Name ProfileConfig -Description "Contains configuration global information for the Advanced PowerShell Console" -Value $newProfileConfig -Scope Global -Option Readonly
}