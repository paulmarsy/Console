Set-Alias su Open-Superuser
function Open-Superuser
{
    Start-Process -FilePath "$InstallPath\Console\ConEmu64.exe" -ArgumentList "/cmd powershell.exe" -Verb RunAs -WorkingDirectory $pwd
    Exit
}
@{Function = "Open-Superuser"; Alias = "su"}