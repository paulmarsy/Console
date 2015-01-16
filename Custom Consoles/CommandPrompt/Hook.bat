@ECHO OFF

SETLOCAL EnableDelayedExpansion

SET InitializeFile="%CustomConsolesInstallPath%Custom Consoles\CommandPrompt\Initialize.bat"

"%CustomConsolesInstallPath%Libraries\Custom Helper Apps\ExtensibleEnvironmentTester\ExtensibleEnvironmentTester.exe"
IF %ERRORLEVEL% == 0 (
	CALL %InitializeFile%
	ENDLOCAL && SET PROMPT=%PROMPT%
) ELSE (
	IF %ERRORLEVEL% == 10 (
 		ECHO Not starting Command Prompt Console as we are not using ConEmu. To override:
		ECHO CALL %InitializeFile%
		ENDLOCAL
	) ELSE (
		ENDLOCAL
	)
)

EXIT /B 0
