@ECHO OFF

SET CommandPromptConsoleModulePath=%PowerShellConsoleInstallPath%\CommandPromptConsole
SET CommandPromptConsoleLibraries=%PowerShellConsoleInstallPath%\Libraries
SET CommandPromptConsoleSublimeExecutable=%CommandPromptConsoleLibraries%\Sublime Text\sublime_text.exe

FOR /F "tokens=3 delims= " %%G IN ('REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal"') DO (SET MyDocuments=%%G)
SET UserFolder=%MyDocuments%\PowerShell Console
SET AppSettingsFolder=%UserFolder%\App Settings