function Set-RemoteAccessCredentials {
    param(
        [Parameter(Mandatory=$false, Position=1)][System.String]$Username = ("{0}\{1}" -f ([Environment]::UserDomainName), ([Environment]::UserName)),
        [Parameter(Mandatory=$false, Position=2)][System.String]$Password = $null
    )
    
    do {
        $windowsCredentials = Get-Credential -Username $Username -Message "Enter your logon credentials to use for remote access"
        $windowsLogon = @{
            UserName = $windowsCredentials.UserName
            Password = $windowsCredentials.Password.Peek()
        }
    } while ([string]::IsNullOrWhiteSpace($windowsLogon.UserName) -or ([string]::IsNullOrWhiteSpace($windowsLogon.Password))) 
    
    Write-Host -ForegroundColor DarkGreen "Setting Windows User Access Credentials for '$Username'..." -NoNewLine
    Set-ProtectedProfileConfigSetting -Name "WindowsUserAccessCredentials" -Value $windowsLogon -Force
    Save-ProfileConfig -Quiet
    Write-Host -ForegroundColor DarkGreen " Done."
}