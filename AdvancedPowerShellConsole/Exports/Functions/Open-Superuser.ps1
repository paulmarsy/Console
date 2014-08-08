function Open-Superuser
{
    Start-Process -FilePath "$InstallPath\Third Party\Console\ConEmu64.exe" -ArgumentList "/cmd powershell.exe -cur_console:na" -WorkingDirectory $pwd
    Exit
}