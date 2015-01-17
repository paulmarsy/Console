@ECHO OFF

MODE CON: COLS=120 LINES=40
TITLE Installing PowerShell Console...

CD /D %~dp0

SET POWERSHELLSWITCHES=-NoProfile -ExecutionPolicy RemoteSigned -File .\Install.ps1
SET COMMANDLINEARGS=%*

powershell.exe %POWERSHELLSWITCHES% -DisplayInfo
powershell.exe %POWERSHELLSWITCHES% -PreReqCheck
IF NOT %ERRORLEVEL% == 0 GOTO END

powershell.exe %POWERSHELLSWITCHES% -InitializeGit
IF NOT %ERRORLEVEL% == 0 GOTO ERROR
powershell.exe %POWERSHELLSWITCHES% -PowerShellConsoleUserFolders
IF NOT %ERRORLEVEL% == 0 GOTO ERROR
%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe %POWERSHELLSWITCHES% -Specific
IF NOT %ERRORLEVEL% == 0 GOTO ERROR
%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe %POWERSHELLSWITCHES% -Specific
IF NOT %ERRORLEVEL% == 0 GOTO ERROR
powershell.exe %POWERSHELLSWITCHES% -Mixed
IF NOT %ERRORLEVEL% == 0 GOTO ERROR
powershell.exe %POWERSHELLSWITCHES% -Finalize %COMMANDLINEARGS%
IF NOT %ERRORLEVEL% == 0 GOTO ERROR

GOTO END

:ERROR
ECHO "Install failed, aborting."

:END
PAUSE
