Set-Alias su Open-Superuser
function Open-Superuser
{
    Start-Process -FilePath "$InstallPath\Console\ConEmu64.exe" -ArgumentList "/cmd powershell.exe -cur_console:na" -WorkingDirectory $pwd
    Exit
}
@{Function = "Open-Superuser"; Alias = "su"}