if (Get-Module ProfileConfig) {
	Remove-Module ProfileConfig
}
Import-Module (Join-Path $ExecutionContext.SessionState.Module.ModuleBase "ProfileConfig") -ArgumentList $InstallPath -Global -Force