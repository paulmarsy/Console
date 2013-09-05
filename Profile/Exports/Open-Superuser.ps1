Remove-Item Alias:\su
Set-Alias su Open-Superuser
function Open-Superuser
{
    Start-Process -FilePath "$InstallPath\ConEmu\ConEmu.exe" -ArgumentList "/cmd powershell.exe" -Verb RunAs -WorkingDirectory $pwd
}