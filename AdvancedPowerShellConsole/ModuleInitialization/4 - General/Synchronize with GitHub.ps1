if (Test-NetworkStatus) {
	if (Assert-ConsoleIsInSync -Quiet) {
		Sync-ConsoleWithGitHub -DontPushToGitHub -UpdateConsole Auto
	} else {
		_updateGitHubCmdletParameters
	}
} else {
	Write-Host -ForegroundColor Red "Unable to synchronise with GitHub due to a lack of network connectivity"
}