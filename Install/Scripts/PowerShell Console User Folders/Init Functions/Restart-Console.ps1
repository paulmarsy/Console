function Restart-Console {
	param(
		$Message = "PowerShell Console has been restarted",
		[switch]$Su
	)
	
	[System.Environment]::SetEnvironmentVariable("PowerShellConsoleStartUpMessage", $Message, [System.EnvironmentVariableTarget]::Process)
	[System.Environment]::SetEnvironmentVariable("PowerShellConsoleStartUpPath", $PWD.Path, [System.EnvironmentVariableTarget]::Process)

    Start-Process -FilePath "##ConEmuExecutablePath##" -ArgumentList "/cmd $(if ($Su) { "{PowerShell (Administrator)}" } else { "{PowerShell}" })"
	$Host.SetShouldExit(0)
}