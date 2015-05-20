@ECHO off

SET ExeFile=NotepadHijackHelper.exe

IF EXIST %ExeFile% DEL %ExeFile%

CALL "%VS120COMNTOOLS%\VsDevCmd.bat"

csc.exe /optimize+ /highentropyva+ /t:winexe /platform:anycpu /out:%ExeFile% /main:NotepadHijackHelper.Program /recurse:src\*.cs

PAUSE