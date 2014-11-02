function Start-PowerShellConsole {
	param(
		[switch]$Force
	)

	if (Get-Process -Id (Get-WmiObject Win32_Process -Filter "ProcessId='$PID'").ParentProcessId | `
	% Name | `
	? { $_ -notlike "ConEmuC*" -and -not $Force }) {
		Write-Host -ForegroundColor Red "Not starting PowerShell Console as we are not using ConEmu. Use the -Force switch to override."
		return
	}

	Test-PowerShellConsoleFlagFile

	if ((Test-Path "##PowerShellConsoleDisabledFlagFile##") -and -not $Force) {
	    Write-Host -ForegroundColor Red "Not starting PowerShell Console, disabled flag is set. Either enable the flag file or use the -Force switch"
	    return
	}

	Import-Module "##PowerShellConsoleModulePath##" -ArgumentList "##InstallPath##" -Force -Global
}