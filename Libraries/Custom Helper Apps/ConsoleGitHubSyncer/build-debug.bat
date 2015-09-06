@ECHO off

SET ExeFile=ConsoleGitHubSyncer.exe

IF EXIST %ExeFile% DEL %ExeFile%

CALL "%VS140COMNTOOLS%\VsDevCmd.bat"

csc.exe /optimize+ /highentropyva+ /t:exe /platform:anycpu /out:%ExeFile% /main:ConsoleGitHubSyncer.Program /recurse:src\*.cs /define:DEBUG

PAUSE