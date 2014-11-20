# Update PSModulePath to reference 'PowerShell Modules' directory
$PSModulePath = $Env:PSModulePath + ";" + (Join-Path $ConsoleRoot "Libraries\PowerShell Modules")
[System.Environment]::SetEnvironmentVariable("PSModulePath", $PSModulePath, [System.EnvironmentVariableTarget]::Process)