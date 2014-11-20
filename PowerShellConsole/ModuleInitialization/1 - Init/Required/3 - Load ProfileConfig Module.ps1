if (Get-Module ProfileConfig) {
	Remove-Module ProfileConfig
}
Import-Module (Join-Path $InstallPath "ProfileConfig") -Global -Force