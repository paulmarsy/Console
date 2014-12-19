function Initialize-ProfileConfig {
    if (Test-Path Variable:Global:ProfileConfig) {
        Remove-Variable -Name ProfileConfig -Scope Global -Force
    }

    if (Test-Path $profileConfigFile) {
        $importedProfileConfig =  Get-Content -Path $profileConfigFile -Raw | ConvertFrom-Json
    } else {
        $importedProfileConfig = $null
    }

    $newProfileConfig = New-ProfileConfig -OverrideProfileConfig $importedProfileConfig
    New-Variable -Name ProfileConfig -Description "Contains configuration global information for the PowerShell Console" -Value $newProfileConfig -Scope Global -Option Readonly

    $destructor = {
        Save-ProfileConfig -Quiet
    }

    $psEngineExitEventJob = Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action $destructor

    $ExecutionContext.SessionState.Module.OnRemove = {
        $psEngineExitEventJob | Stop-Job -PassThru | Remove-Job

        $destructor.Invoke()
    }.GetNewClosure()
}