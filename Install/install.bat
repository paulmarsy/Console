@ECHO OFF
..\Binaries\hstart.exe /ELEVATE "CMD /C CD /D %~dp0\Scripts & powershell.exe -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -File .\Install.ps1 & PAUSE"