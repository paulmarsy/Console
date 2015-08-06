function Get-RemoteAccessCredentials {
    if ($MyInvocation.CommandOrigin -eq ([System.Management.Automation.CommandOrigin]::Runspace)) {
        # Very basic form of protection but if someone has access to this they could just decrypt it manually and completely byoass us
        throw "Unable to retrieve remote access credentials interactivley"
    }
    return (Get-ProtectedProfileConfigSetting -Name "WindowsUserAccessCredentials")
}