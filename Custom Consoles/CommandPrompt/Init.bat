@ECHO OFF

"%CustomConsolesInstallPath%\Libraries\ExtensibleEnvironmentTester\ExtensibleEnvironmentTester.exe"
IF NOT %ERRORLEVEL% == 0 EXIT /B

CALL "%CustomConsolesInstallPath%\Config\Constants.bat"

FOR %%v IN ("%CommandPromptConsoleModulePath%\ModuleInitialization\*.bat") DO CALL "%%~v"