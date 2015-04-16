@ECHO OFF

MODE CON: COLS=120 LINES=40
TITLE Installing PowerShell Console Prerequisites...

CD /D %~dp0

SET POWERSHELLSWITCHES=-NoProfile -ExecutionPolicy RemoteSigned -File .\InstallPrerequisites.ps1

powershell.exe %POWERSHELLSWITCHES%
IF NOT %ERRORLEVEL% == 0 GOTO ERROR

GOTO END

:ERROR
ECHO "Install failed, aborting."

:END
PAUSE
