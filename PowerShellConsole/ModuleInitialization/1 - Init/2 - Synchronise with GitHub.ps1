param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

$consoleGitHubSyncer = $PowerShellConsoleConstants.Executables.ConsoleGitHubSyncer

& $consoleGitHubSyncer -Check $PowerShellConsoleConstants.InstallPath | Out-Host

switch ($LASTEXITCODE) {
	0 {
		Write-Host -ForegroundColor Green "Git repository is up to date with GitHub changes"
		& $consoleGitHubSyncer -InitializeRepositoryForUse $PowerShellConsoleConstants.InstallPath | Out-Host
	}
	10 {
		Write-Host -ForegroundColor Red  "Unable to synchronize while the Git working tree has uncommitted changes"
	}
	160 {
		Write-Host -ForegroundColor Red  "Git exited unexpectedly"
	}
	1306 {
		[System.Diagnostics.Process]::Start($PowerShellConsoleConstants.Executables.Hstart, "/DELAY=3 `"`"$consoleGitHubSyncer`" -Synchronize `"$($PowerShellConsoleConstants.InstallPath)`" `"$($PowerShellConsoleConstants.Executables.ConEmu)`" `"/cmd {PowerShell}`" `"")
		#[System.Environment]::Exit(0)
	}
	default { 	Write-Warning "ConsoleGitHubSyncer failed with error code $LASTEXITCODE" }
}