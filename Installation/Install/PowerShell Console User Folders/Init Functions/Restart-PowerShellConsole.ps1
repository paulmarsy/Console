function Restart-PowerShellConsole {
	param(
		$Message = "PowerShell Console has been restarted",
		[switch]$Su
	)
	
	$Env:PowerShellConsoleStartUpMessage = $Message
	$Env:PowerShellConsoleStartUpPath = $PWD.Path
	Start-Process -FilePath "##ConEmuCExecutablePath##" -NoNewWindow -ArgumentList "/EXPORT PowerShellConsoleStartUpMessage PowerShellConsoleStartUpPath" -Wait

    Start-Process -FilePath "##ConEmuExecutablePath##" -ArgumentList "/cmd $(if ($Su) { "{PowerShell (Administrator)}" } else { "{PowerShell}" })"
	[System.Environment]::Exit(0)
}