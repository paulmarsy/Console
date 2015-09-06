param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $false}) }

$pathExtensionsDir = Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\PATH Extensions"

$Path = @(
	$Env:PATH
	$pathExtensionsDir
	(Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\nmap\App")
	(Get-ChildItem -Path $pathExtensionsDir -Directory | % FullName | ? { $Env:PATH -notlike ("*{0}*" -f $_) })
) -Join ([System.IO.Path]::PathSeparator)

[System.Environment]::SetEnvironmentVariable("PATH", $Path, [System.EnvironmentVariableTarget]::Process)
