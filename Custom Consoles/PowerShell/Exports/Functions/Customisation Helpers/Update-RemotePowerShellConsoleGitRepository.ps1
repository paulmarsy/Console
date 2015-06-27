function Update-RemotePowerShellConsoleGitRepository {
	$consoleGitHubSyncer = Join-Path $InstallPath "Libraries\Custom Helper Apps\ConsoleGitHubSyncer\ConsoleGitHubSyncer.exe"

	$consoleGitHubSyncerCheck = Start-Process -FilePath $consoleGitHubSyncer -ArgumentList "-UpdateRemote `"$($InstallPath.TrimEnd('\'))`" " -NoNewWindow -Wait -PassThru

	if ($consoleGitHubSyncerCheck.ExitCode -eq 1306) {
		Start-Process -FilePath $PowerShellConsoleConstants.Executables.ConEmuC -ArgumentList "-GuiMacro Close(2)" -Wait -WindowStyle Hidden
		Get-Host | % SetShouldExit 0
	}
}
