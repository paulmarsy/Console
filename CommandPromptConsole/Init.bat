@ECHO OFF

"%PowerShellConsoleInstallPath%\Libraries\ExtensibleEnvironmentTester\ExtensibleEnvironmentTester.exe"
IF NOT %ERRORLEVEL% == 0 EXIT /B

CALL "%PowerShellConsoleInstallPath%\Constants.bat"

FOR %%v IN ("%CommandPromptConsoleModulePath%\ModuleInitialization\*.bat") DO CALL "%%~v"