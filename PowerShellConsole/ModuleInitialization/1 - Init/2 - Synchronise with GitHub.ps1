param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

$consoleGitHubSyncer = $PowerShellConsoleConstants.Executables.ConsoleGitHubSyncer

& $consoleGitHubSyncer -Check $PowerShellConsoleConstants.InstallPath

switch ($LASTEXITCODE) {
	0 { & $consoleGitHubSyncer -InitializeRepositoryForUse $PowerShellConsoleConstants.InstallPath }
	1306 { & $consoleGitHubSyncer -Synchronize $PowerShellConsoleConstants.InstallPath; [System.Environment]::Exit(0) }
	default { 	Write-Warning "ConsoleGitHubSyncer failed with error code $LASTEXITCODE" }
}