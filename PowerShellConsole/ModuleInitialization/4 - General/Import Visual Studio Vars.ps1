param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return 1 }

if (Test-Path Env:VS120COMNTOOLS) {
	Import-VisualStudioVars 2013
} elseif (Test-Path Env:VS110COMNTOOLS) {
	Import-VisualStudioVars 2012
} elseif (Test-Path Env:VS100COMNTOOLS) {
	Import-VisualStudioVars 2010
} else {
    Write-Warning "Unable to detect Visual Studio (2013, 2012 or 2010) to be able to import the Visual Studio Tools environment"
}