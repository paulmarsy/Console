param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return -1 }

if (Get-Module ProfileConfig) {
	Remove-Module ProfileConfig
}
Import-Module (Join-Path $InstallPath "ProfileConfig") -Global -Force