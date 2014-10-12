$advancedPowerShellConsolePath = [System.Environment]::GetEnvironmentVariable("AdvancedPowerShellConsoleStartUpPath", [System.EnvironmentVariableTarget]::Process)
if (-not [string]::IsNullOrWhiteSpace($advancedPowerShellConsolePath)) {
    Set-Location -Path $advancedPowerShellConsolePath
    [System.Environment]::SetEnvironmentVariable("AdvancedPowerShellConsoleStartUpPath", $null, [System.EnvironmentVariableTarget]::Process)
} else {
	Set-Location -Path $ProfileConfig.General.PowerShellScratchpadFolder
}