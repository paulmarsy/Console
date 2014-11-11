$PowerShellConsolePath = [System.Environment]::GetEnvironmentVariable("PowerShellConsoleStartUpPath", [System.EnvironmentVariableTarget]::Process)
if (-not [string]::IsNullOrWhiteSpace($PowerShellConsolePath)) {
    Set-Location -Path $PowerShellConsolePath
    [System.Environment]::SetEnvironmentVariable("PowerShellConsoleStartUpPath", $null, [System.EnvironmentVariableTarget]::Process)
} else {
	Set-Location -Path $ProfileConfig.General.UserFolder
}