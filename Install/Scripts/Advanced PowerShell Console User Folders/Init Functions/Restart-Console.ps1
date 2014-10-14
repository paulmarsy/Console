function Restart-Console {
	param(
		$Message = "Advanced PowerShell Console has been restarted",
		[switch]$Su
	)
	
	[System.Environment]::SetEnvironmentVariable("AdvancedPowerShellConsoleStartUpMessage", $Message, [System.EnvironmentVariableTarget]::Process)
	[System.Environment]::SetEnvironmentVariable("AdvancedPowerShellConsoleStartUpPath", $pwd, [System.EnvironmentVariableTarget]::Process)

    Start-Process -FilePath "##ConEmuExecutablePath##" -ArgumentList "/cmd $(if ($Su) { "{PowerShell (Administrator)}" } else { "{PowerShell}" })"
	$Host.SetShouldExit(0)
}