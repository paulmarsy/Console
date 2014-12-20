@ECHO OFF

CALL "%CustomConsolesInstallPath%\Config\Constants.bat"

FOR %%v IN ("%CommandPromptConsoleModulePath%\ModuleInitialization\*.bat") DO CALL "%%~v"

ECHO %AnsiEsc%[1;32;40mCommand Prompt Console successfully loaded