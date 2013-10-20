function Restart-Console {
    Start-Process -FilePath "$InstallPath\Console\ConEmu64.exe" -ArgumentList "/cmd powershell.exe" -WorkingDirectory $pwd
    Exit
}
@{Function = "Restart-Console"}