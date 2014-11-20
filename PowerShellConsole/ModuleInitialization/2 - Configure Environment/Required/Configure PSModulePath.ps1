# Update PSModulePath to reference 'PowerShell Modules' directory
$PSModulePath = $Env:PSModulePath + ";" + (Join-Path $ProfileConfig.Module.InstallPath "Libraries\PowerShell Modules")
[System.Environment]::SetEnvironmentVariable("PSModulePath", $PSModulePath, [System.EnvironmentVariableTarget]::Process)