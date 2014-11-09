if (-not $StartAfterInstall) {
	return
}

$Message = "PowerShell Console has been "
if ($AutomatedReinstall) {
	$Message += "reinstalled"
} else {
	$Message += "installed"
}

[System.Environment]::SetEnvironmentVariable("PowerShellConsoleStartUpMessage", $Message, [System.EnvironmentVariableTarget]::Process)