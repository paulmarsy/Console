param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

$consoleGitHubSyncer = $PowerShellConsoleConstants.Executables.ConsoleGitHubSyncer

$consoleGitHubSyncerCheck = Start-Process -FilePath $consoleGitHubSyncer -ArgumentList "-Check $($PowerShellConsoleConstants.InstallPath)" -PassThru -NoNewWindow -Wait

if ($consoleGitHubSyncerCheck.ExitCode -eq 1306) {
	try {
		$mutex = [System.Threading.Mutex]::new($false, $PowerShellConsoleConstants.MutexGuid)
		while(-not $mutex.WaitOne([TimeSpan]::FromSeconds(1).TotalMilliseconds, $false)) {
			Write-Host "Waiting to aquire mutex..."
		}
	}
	catch [System.Threading.AbandonedMutexException] { }
	[System.Diagnostics.Process]::Start($PowerShellConsoleConstants.Executables.Hstart, "`"`"$consoleGitHubSyncer`" -UpdateLocal `"$($PowerShellConsoleConstants.InstallPath.TrimEnd('\'))`" `"$($PowerShellConsoleConstants.Executables.ConEmu)`" `"/cmd {PowerShell}`" `"")
	[System.Environment]::Exit(0)
}