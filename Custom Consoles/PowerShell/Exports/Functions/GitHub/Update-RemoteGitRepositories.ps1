function Update-RemoteGitRepositories {
$consoleGitHubSyncer = Join-Path $InstallPath "Libraries\Custom Helper Apps\ConsoleGitHubSyncer\ConsoleGitHubSyncer.exe"

Start-Process -FilePath $consoleGitHubSyncer -ArgumentList "-UpdateRemote `"$($InstallPath.TrimEnd('\'))`" " -NoNewWindow -Wait

}