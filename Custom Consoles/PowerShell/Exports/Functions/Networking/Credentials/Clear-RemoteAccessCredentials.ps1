function Clear-RemoteAccessCredentials {
    Write-Host -ForegroundColor DarkGreen "Voiding Windows User Access Credentials..." -NoNewLine
    Set-ProtectedProfileConfigSetting -Name "WindowsUserAccessCredentials" -Value ([string]::Empty) -Force
    Write-Host -ForegroundColor DarkGreen " Done."
}