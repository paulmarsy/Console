@ECHO OFF

PUSHD %PowerShellConsoleInstallPath%
rem FOR /F "tokens=*" %%a in ('powershell.exe -NoProfile -Command "$PowerShellConsoleConstants = & '.\Constants.ps1'; $PowerShellConsoleConstants.UserFolders.AppSettingsFolder"') DO SET AppSettingsFolder=%%a
echo %AppSettingsFolder%
POPD

SET CommandPromptConsoleModulePath=%PowerShellConsoleInstallPath%\CommandPromptConsole

CALL "%CommandPromptConsoleModulePath%\Load Clink.bat"