function Clear-RemoteAccessCredentials {
    Write-Host -ForegroundColor DarkGreen "Voiding Windows User Access Credentials..." -NoNewLine
    Set-ProtectedProfileConfigSetting -Name "WindowsUserAccessCredentials" -Value $null -Force
    Save-ProfileConfig -Quiet
    Write-Host -ForegroundColor DarkGreen " Done."
}