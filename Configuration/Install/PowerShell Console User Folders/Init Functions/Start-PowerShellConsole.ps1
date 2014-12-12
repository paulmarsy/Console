function Start-PowerShellConsole {
	param(
		[switch]$Force
	)

	$extensibleEnvironmentTester = Start-Process -FilePath "##InstallPath##\Libraries\ExtensibleEnvironmentTester\ExtensibleEnvironmentTester.exe" -PassThru -NoNewWindow -Wait
	if ($extensibleEnvironmentTester.ExitCode -ne 0 -and -not $Force) {
		Write-Host -ForegroundColor Red "Not starting PowerShell Console as we are not using ConEmu. Use the -Force switch to override."
		return
	}

	Test-PowerShellConsoleFlagFile

	if ((Test-Path "##PowerShellConsoleDisabledFlagFile##") -and -not $Force) {
	    Write-Host -ForegroundColor Red "Not starting PowerShell Console, disabled flag is set. Either enable the flag file or use the -Force switch"
	    return
	}

	Import-Module "##PowerShellConsoleModulePath##" -Force -Global
}