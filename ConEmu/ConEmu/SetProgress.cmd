@echo off

rem Usage:
rem   SetProgress
rem     -- Several sample calls delimited with "pause"
rem   SetProgress 0
rem     -- Remove progress state
rem   SetProgress 1 <Percents>
rem     -- Set progress to specified value (0..100)
rem   SetProgress 2
rem     -- Set progress error state

rem Run this file in cmd.exe or tcc.exe to change
rem Title of console window.

rem Note!
rem "Inject ConEmuHk" and "ANSI X3.64" options
rem must be turned ON in ConEmu Settings!

set ESC=

if not "%~1"=="" goto set_pr

rem Without parameters - run demo

echo %ESC%[s
echo %ESC%[s

echo %ESC%[u%ESC%[KPress enter to set 30%% progress...
pause>nul
call :set_pr 1 30

echo %ESC%[u%ESC%[KPress enter to set 60%% progress
pause>nul
call :set_pr 1 60

echo %ESC%[u%ESC%[KPress enter to set Error state
pause>nul
call :set_pr 2

echo %ESC%[u%ESC%[KPress enter to remove progress
pause>nul
call :set_pr 0

echo %ESC%[u%ESC%[K

goto :EOF

:set_pr
echo %ESC%]9;4;%~1;%~2%ESC%\
