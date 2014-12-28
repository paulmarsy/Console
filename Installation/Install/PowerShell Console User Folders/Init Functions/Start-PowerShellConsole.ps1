function Start-PowerShellConsole {
	param(
		[switch]$Force
	)

	$extensibleEnvironmentTester = Start-Process -FilePath "##InstallPath##\Libraries\Custom Helper Apps\ExtensibleEnvironmentTester\ExtensibleEnvironmentTester.exe" -PassThru -NoNewWindow -Wait
	if ($extensibleEnvironmentTester.ExitCode -ne 0 -and -not $Force) {
		Write-Host -ForegroundColor Red "Not starting PowerShell Console as we are not using ConEmu. Use the -Force switch to override."
		return
	}

	Test-PowerShellConsoleFlagFile

	if ((Test-Path "##PowerShellConsoleDisabledFlagFile##") -and -not $Force) {
	    Write-Host -ForegroundColor Red "Not starting PowerShell Console as the disabled flag is set. Enable the flag with Enable-PowerShellConsole or use the -Force switch"
	    return
	}

	Import-Module "##PowerShellConsoleModulePath##" -Force -Global
}