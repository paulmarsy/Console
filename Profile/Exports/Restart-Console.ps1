function Restart-Console {
    Start-Process -FilePath "$InstallPath\Third Party\Console\ConEmu64.exe" -ArgumentList "/cmd powershell.exe" -WorkingDirectory $pwd
    Exit
}
@{Function = "Restart-Console"}