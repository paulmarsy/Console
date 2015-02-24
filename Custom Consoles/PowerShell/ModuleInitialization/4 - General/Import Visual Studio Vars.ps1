param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

if (Test-Path Env:VS120COMNTOOLS) {
	Import-VisualStudioVars -VisualStudioVersion 2013 -Architecture amd64
}