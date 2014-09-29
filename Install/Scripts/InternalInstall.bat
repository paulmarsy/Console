@ECHO OFF

MODE CON: COLS=120 LINES=35
TITLE Installing Console...

rem CD /D %~dp0

SET POWERSHELLSWITCHES=-NoProfile -ExecutionPolicy RemoteSigned
SET COMMANDLINEARGS=%*

powershell.exe %POWERSHELLSWITCHES% -File .\Install.ps1 -DisplayInfo 

powershell.exe %POWERSHELLSWITCHES% -File .\Install.ps1 -PreReqCheck 

IF ERRORLEVEL 1 GOTO END

%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe %POWERSHELLSWITCHES% -File .\Install.ps1 -Specific
%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe %POWERSHELLSWITCHES% -File .\Install.ps1 -Specific
powershell.exe %POWERSHELLSWITCHES% -File .\Install.ps1 -Mixed
powershell.exe %POWERSHELLSWITCHES% -File .\Install.ps1 -Finalize %COMMANDLINEARGS%

:END
PAUSE