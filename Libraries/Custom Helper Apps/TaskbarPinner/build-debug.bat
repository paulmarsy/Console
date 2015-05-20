@ECHO off

SET ExeFile=TaskbarPinner.exe

IF EXIST %ExeFile% DEL %ExeFile%

CALL "%VS120COMNTOOLS%\VsDevCmd.bat"

csc.exe /optimize+ /highentropyva+ /t:exe /platform:anycpu /out:%ExeFile% /main:TaskbarPinner.Program /recurse:src\*.cs /define:DEBUG

PAUSE