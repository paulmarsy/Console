SET ClinkPath=%PowerShellConsoleInstallPath%\Libraries\Clink

SET ClinkArgs=inject --profile "%AppSettingsFolder%\ClinkProfile" 

IF /i "%PROCESSOR_ARCHITECTURE%"=="x86" (
	CALL "%ClinkPath%\clink_x86.exe" %ClinkArgs%
) ELSE IF /i "%PROCESSOR_ARCHITECTURE%"=="amd64" (
	CALL "%ClinkPath%\clink_x64.exe" %ClinkArgs%
)