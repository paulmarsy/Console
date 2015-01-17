@ECHO OFF

MODE CON: COLS=120 LINES=40
TITLE Uninstalling PowerShell Console...

CD /D %~dp0

SET POWERSHELLSWITCHES=-NoProfile -ExecutionPolicy RemoteSigned -File .\Uninstall.ps1

powershell.exe %POWERSHELLSWITCHES% -DisplayInfo
powershell.exe %POWERSHELLSWITCHES% -PowerShellConsoleUserFolders
IF NOT %ERRORLEVEL% == 0 GOTO ERROR
powershell.exe %POWERSHELLSWITCHES% -General
IF NOT %ERRORLEVEL% == 0 GOTO ERROR
powershell.exe %POWERSHELLSWITCHES% -Finalize
IF NOT %ERRORLEVEL% == 0 GOTO ERROR

GOTO END

:ERROR
ECHO "Uninstall failed, aborting."

:END
PAUSE
