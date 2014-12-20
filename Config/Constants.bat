@ECHO OFF

SET CommandPromptConsoleModulePath=%CustomConsolesInstallPath%\Custom Consoles\CommandPrompt
SET CommandPromptConsoleLibraries=%CustomConsolesInstallPath%\Libraries
SET CommandPromptConsoleSublimeExecutable=%CommandPromptConsoleLibraries%\Sublime Text\sublime_text.exe
set AnsiEsc=


FOR /F "tokens=3 delims= " %%G IN ('REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal"') DO (SET MyDocuments=%%G)
SET UserFolder=%MyDocuments%\PowerShell Console
SET AppSettingsFolder=%UserFolder%\App Settings