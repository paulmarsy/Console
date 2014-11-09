function Initialize-ProfileConfig {
    if (Test-Path Variable:Global:ProfileConfig) {
        Remove-Variable -Name ProfileConfig -Scope Global -Force
    }

    if (Test-Path $profileConfigFile) {
        $importedProfileConfig =  Get-Content -Path $profileConfigFile | ConvertFrom-Json
    } else {
        $importedProfileConfig = $null
    }

    $newProfileConfig = New-ProfileConfig -OverrideProfileConfig $importedProfileConfig
    New-Variable -Name ProfileConfig -Description "Contains configuration global information for the PowerShell Console" -Value $newProfileConfig -Scope Global -Option Readonly

    $saveProfileConfig = Get-Item -Path Function:\Save-ProfileConfig
    $eventJob = Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action $saveProfileConfig.ScriptBlock

    $ExecutionContext.SessionState.Module.OnRemove = {
        $eventJob | Stop-Job -PassThru | Remove-Job

        $saveProfileConfig.ScriptBlock.Invoke()
    }.GetNewClosure()
}