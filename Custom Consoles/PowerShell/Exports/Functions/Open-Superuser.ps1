function Open-Superuser
{
	if ($ProfileConfig.General.IsAdmin) {
		throw "Already running with Administrator access"
	}
	else { Restart-PowerShellConsole -Su }
}