param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

switch ($ProfileConfig.TFS.Version)
{
	"2013" {
		if (Test-Path Env:VS120COMNTOOLS) {
			Import-VisualStudioVars -VisualStudioVersion 2013 -Architecture amd64
		}
	}
	"2010" {
		if (Test-Path Env:VS100COMNTOOLS) {
			Import-VisualStudioVars -VisualStudioVersion 2010 -Architecture amd64
		}
	}
}

