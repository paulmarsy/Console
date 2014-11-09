@ECHO OFF

MODE CON: COLS=120 LINES=50
TITLE Uninstalling PowerShell Console...

CD /D %~dp0

SET POWERSHELLSWITCHES=-NoProfile -ExecutionPolicy RemoteSigned -File .\Uninstall.ps1

powershell.exe %POWERSHELLSWITCHES% -DisplayInfo 
powershell.exe %POWERSHELLSWITCHES% -PowerShellConsoleUserFolders
powershell.exe %POWERSHELLSWITCHES% -General
powershell.exe %POWERSHELLSWITCHES% -Finalize

:END
PAUSE