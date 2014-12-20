"%CustomConsolesInstallPath%\Libraries\ExtensibleEnvironmentTester\ExtensibleEnvironmentTester.exe"
IF NOT %ERRORLEVEL% == 0 (
	CALL "%CommandPromptConsoleLibraries%\AnsiCon\ansicon.exe" -p
)
