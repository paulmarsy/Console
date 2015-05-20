@ECHO off

CD /d %~dp0

SET ExeFile=ExtensibleEnvironmentTester.exe

IF EXIST %ExeFile% DEL %ExeFile%

CALL "%VS120COMNTOOLS%\VsDevCmd.bat"

csc.exe /optimize+ /highentropyva+ /t:exe /platform:anycpu /out:%ExeFile% /main:ExtensibleEnvironmentTester.Program /recurse:src\*.cs
ngen.exe install %ExeFile% /verbose

PAUSE