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

    $backgroundSaveTask = { Save-ProfileConfig -Quiet }
    $Global:OnIdleScriptBlockCollection += $backgroundSaveTask
    $ExecutionContext.SessionState.Module.OnRemove = $backgroundSaveTask
}