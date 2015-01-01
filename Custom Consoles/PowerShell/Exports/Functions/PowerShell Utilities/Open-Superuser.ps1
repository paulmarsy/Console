function Open-Superuser
{
	$windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
	$windowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal $windowsIdentity
	if ($windowsPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
		throw "Already running with Administrator access"
	}
	else { Restart-PowerShellConsole -Su }
}