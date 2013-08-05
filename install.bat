@echo off

whoami /groups | findstr /b BUILTIN\Administrators | findstr /c:"Enabled group" > nul && goto :isadministrator

echo Error! Requires Administrator privileges
goto :end

:isadministrator

pushd "%~dp0"
powershell.exe -NoProfile -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
powershell.exe -NoProfile -Command "Get-ChildItem .\Install -Filter *.ps1 | %% { & $_.FullName -InstallPath $pwd.Path }"

:end
pause