param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

$pythonCoreRegKey = "HKLM:\SOFTWARE\Wow6432Node\Python\PythonCore"
if (-not (Test-Path $pythonCoreRegKey)) {
	return
}

$installedPythonRegKey = Join-Path (Get-ChildItem -Path $pythonCoreRegKey | Select-Object -First 1 -ExpandProperty PSPath) "InstallPath"
$pythonDir = Get-ItemProperty -Path $installedPythonRegKey | % "(default)"

if (-not (Test-Path $pythonDir)) {
	return
}

if ($Env:PATH.Contains($pythonDir)) {
	return
}

$updatedPath = "{0};{1}" -f $Env:PATH, $pythonDir
[System.Environment]::SetEnvironmentVariable("PATH", $updatedPath, [System.EnvironmentVariableTarget]::Process)