if (Get-Module ProfileConfig) {
	Remove-Module ProfileConfig
}
Import-Module (Join-Path $ConsoleRoot "ProfileConfig") -Global -Force