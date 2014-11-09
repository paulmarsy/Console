# Update PATH to reference 'Binaries' directory and subdirectories
$Path = $Env:PATH + ";" + (Join-Path $ConsoleRoot "Libraries\Binaries") + ";" + (((Get-ChildItem (Join-Path $ConsoleRoot "Libraries\Binaries") | ? { $_.psIsContainer } | Select-Object -ExpandProperty FullName) -Join ";").Trim(';'))
[System.Environment]::SetEnvironmentVariable("PATH", $Path, [System.EnvironmentVariableTarget]::Process)

# Update PSModulePath to reference 'PowerShell Modules' directory
$PSModulePath = $Env:PSModulePath + ";" + (Join-Path $ConsoleRoot "Libraries\PowerShell Modules")
[System.Environment]::SetEnvironmentVariable("PSModulePath", $PSModulePath, [System.EnvironmentVariableTarget]::Process)