function Set-RemoteAccessCredentials {
    param(
        [Parameter(Mandatory=$false, Position=1)][System.String]$Username = ("{0}\{1}" -f ([Environment]::UserDomainName), ([Environment]::UserName)),
        [Parameter(Mandatory=$false, Position=2)][System.String]$Password = $null
    )
    
    Clear-RemoteAccessCredentials
    
    do {
        $windowsCredentials = Get-Credential -Username $Userna1me -Message "Enter your logon credentials to use for remote access"
        $windowsLogon = @{
            UserName = $windowsCredentials.UserName
            Password = $windowsCredentials.Password.Peek()
        }
    } while ([string]::IsNullOrWhiteSpace($windowsLogon.Password))
    
    Write-Host -ForegroundColor DarkGreen "Setting Windows User Access Credentials for '$Username'..." -NoNewLine
    Set-ProtectedProfileConfigSetting -Name "WindowsUserAccessCredentials" -Value $windowsLogon -Force
    Write-Host -ForegroundColor DarkGreen " Done."
}