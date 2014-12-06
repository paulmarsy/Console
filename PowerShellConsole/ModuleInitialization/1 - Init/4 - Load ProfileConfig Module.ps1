param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = -1; Critical = $true}) }

if (Get-Module ProfileConfig) {
	Remove-Module ProfileConfig
}
Import-Module (Join-Path $InstallPath "ProfileConfig") -Global -Force