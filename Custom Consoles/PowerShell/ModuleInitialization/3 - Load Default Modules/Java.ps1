param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

$javaRegKey = "HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment"
if (-not (Test-Path $javaRegKey)) {
	return
}

$currentVersionRegKey = Join-Path $javaRegKey (Get-ItemProperty -Path $javaRegKey -Name "CurrentVersion" | Select-Object -First 1 -ExpandProperty CurrentVersion)
$javaHomePath = Join-Path (Get-ItemProperty -Path $currentVersionRegKey -Name "JavaHome" | Select-Object -First 1 -ExpandProperty JavaHome) "bin"

if (-not (Test-Path $javaHomePath)) {
	return
}

if ($Env:PATH.Contains($javaHomePath)) {
	return
}

$updatedPath = "{0};{1}" -f $Env:PATH, $javaHomePath
[System.Environment]::SetEnvironmentVariable("PATH", $updatedPath, [System.EnvironmentVariableTarget]::Process)