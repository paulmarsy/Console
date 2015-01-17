function Update-RemoteConsoleGitRepository {
	$consoleGitHubSyncer = Join-Path $InstallPath "Libraries\Custom Helper Apps\ConsoleGitHubSyncer\ConsoleGitHubSyncer.exe"

	$consoleGitHubSyncerCheck = Start-Process -FilePath $consoleGitHubSyncer -ArgumentList "-UpdateRemote `"$($InstallPath.TrimEnd('\'))`" " -NoNewWindow -Wait -PassThru

	if ($consoleGitHubSyncerCheck.ExitCode -eq 1306) {
		[System.Environment]::Exit(0)
	}
}
