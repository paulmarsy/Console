param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

$lastSync = New-Object -Type System.DateTime -ArgumentList $ProfileConfig.Git.LastAutoSyncTickTime
$nextSyncAfter = $lastSync.AddSeconds($ProfileConfig.Git.SyncIntervalInSeconds)
if ($nextSyncAfter.Ticks -gt (Get-Date | Select-Object -ExpandProperty Ticks)) {
	Write-Host -ForegroundColor Yellow "Not performing GitHub auto sync, next auto sync after $($nextSyncAfter.ToShortDateString()) at $($nextSyncAfter.ToShortTimeString())"
	return
}

$consoleGitHubSyncer = $PowerShellConsoleConstants.Executables.ConsoleGitHubSyncer

$consoleGitHubSyncerCheck = Start-Process -FilePath $consoleGitHubSyncer -ArgumentList "-Check $($PowerShellConsoleConstants.InstallPath)" -PassThru -NoNewWindow -Wait

if ($consoleGitHubSyncerCheck.ExitCode -eq 1306) {
	$ProfileConfig.Git.LastAutoSyncTickTime = [long](Get-Date | Select-Object -ExpandProperty Ticks)
	Save-ProfileConfig -Quiet
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