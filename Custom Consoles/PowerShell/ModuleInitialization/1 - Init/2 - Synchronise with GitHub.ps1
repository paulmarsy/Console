param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

$consoleGitHubSyncer = $PowerShellConsoleConstants.Executables.ConsoleGitHubSyncer

$consoleGitHubSyncerCheck = Start-Process -FilePath $consoleGitHubSyncer -ArgumentList "-Check $($PowerShellConsoleConstants.InstallPath)" -PassThru -NoNewWindow -Wait

if ($consoleGitHubSyncerCheck.ExitCode -eq 1306) {
	[System.Diagnostics.Process]::Start($PowerShellConsoleConstants.Executables.Hstart, "/DELAY=3 `"`"$consoleGitHubSyncer`" -Synchronize `"$($PowerShellConsoleConstants.InstallPath)`" `"$($PowerShellConsoleConstants.Executables.ConEmu)`" `"/cmd {PowerShell}`" `"")
	[System.Environment]::Exit(0)
}