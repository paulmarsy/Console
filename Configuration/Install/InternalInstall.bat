@ECHO OFF

MODE CON: COLS=120 LINES=50
TITLE Installing PowerShell Console...

CD /D %~dp0

SET POWERSHELLSWITCHES=-NoProfile -ExecutionPolicy RemoteSigned -File .\Install.ps1
SET COMMANDLINEARGS=%*

powershell.exe %POWERSHELLSWITCHES% -DisplayInfo 
powershell.exe %POWERSHELLSWITCHES% -PreReqCheck
IF ERRORLEVEL 1 GOTO END

powershell.exe %POWERSHELLSWITCHES% -PowerShellConsoleUserFolders
%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe %POWERSHELLSWITCHES% -Specific
%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe %POWERSHELLSWITCHES% -Specific
powershell.exe %POWERSHELLSWITCHES% -Mixed
powershell.exe %POWERSHELLSWITCHES% -Finalize %COMMANDLINEARGS%

:END
PAUSE