param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

switch ($ProfileConfig.TFS.Version)
{
    "2015" {
		if (Test-Path Env:VS140COMNTOOLS) {
			Import-VisualStudioVars -VisualStudioVersion 140 -Architecture amd64
		}
	}
	"2013" {
		if (Test-Path Env:VS120COMNTOOLS) {
			Import-VisualStudioVars -VisualStudioVersion 2013 -Architecture amd64
		}
	}
}
