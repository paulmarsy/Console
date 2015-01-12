function Open-Superuser
{
	if (-not $ProfileConfig.General.IsAdmin) {
		throw "Already running with Administrator access"
	}
	else { Restart-PowerShellConsole -Su }
}