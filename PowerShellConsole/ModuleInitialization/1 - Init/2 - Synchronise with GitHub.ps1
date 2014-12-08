param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

$consoleGitHubSyncer = $PowerShellConsoleConstants.Executables.ConsoleGitHubSyncer

$consoleGitHubSyncerCheck = Start-Process -FilePath $consoleGitHubSyncer -ArgumentList "-Check $($PowerShellConsoleConstants.InstallPath)" -PassThru -NoNewWindow -Wait

switch ($consoleGitHubSyncerCheck.ExitCode) {
	0 {
		Write-Host -ForegroundColor Green "Git repository is up to date with GitHub changes"
	}
	10 {
		Write-Host -ForegroundColor Red  "Unable to synchronize while the Git working tree has uncommitted changes"
	}
	160 {
		Write-Host -ForegroundColor Red  "Git exited unexpectedly"
	}
	1306 {
		[System.Diagnostics.Process]::Start($PowerShellConsoleConstants.Executables.Hstart, "/DELAY=3 `"`"$consoleGitHubSyncer`" -Synchronize `"$($PowerShellConsoleConstants.InstallPath)`" `"$($PowerShellConsoleConstants.Executables.ConEmu)`" `"/cmd {PowerShell}`" `"")
		[System.Environment]::Exit(0)
	}
	default { 	Write-Warning "ConsoleGitHubSyncer failed with error code $($consoleGitHubSyncerCheck.ExitCode)" }
}