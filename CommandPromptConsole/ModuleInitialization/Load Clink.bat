SET ClinkArgs=inject --quiet --profile "%AppSettingsFolder%\ClinkProfile" 

IF /I "%PROCESSOR_ARCHITECTURE%"=="x86" (
	CALL "%CommandPromptConsoleLibraries%\Clink\clink_x86.exe" %ClinkArgs%
) ELSE IF /I "%PROCESSOR_ARCHITECTURE%"=="amd64" (
	CALL "%CommandPromptConsoleLibraries%\Clink\clink_x64.exe" %ClinkArgs%
)