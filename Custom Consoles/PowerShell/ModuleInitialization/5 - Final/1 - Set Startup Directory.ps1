param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $false}) }

$PowerShellConsolePath = [System.Environment]::GetEnvironmentVariable("PowerShellConsoleStartUpPath", [System.EnvironmentVariableTarget]::Process)
if (-not [string]::IsNullOrWhiteSpace($PowerShellConsolePath)) {
    Set-Location -Path $PowerShellConsolePath
    $Env:PowerShellConsoleStartUpPath = $null
    Start-Process -FilePath $PowerShellConsoleConstants.Executables.ConEmuC -WindowStyle Hidden -ArgumentList "/EXPORT PowerShellConsoleStartUpPath"
} else {
	Set-Location -Path $ProfileConfig.General.UserFolder
}