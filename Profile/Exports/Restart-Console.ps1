function Restart-Console
{
    Start-Process -FilePath "$InstallPath\ConEmu\ConEmu.exe" -ArgumentList "/cmd powershell.exe" -WorkingDirectory $pwd
}