function New-ProfileConfig {
    return @{
        Git = @{
            Name   = "Paul Marston"
            Email  = "vai@vai-net.co.uk"
        }
    }
}

function Export-ProfileConfig {    
    $profileFolder = Split-Path $PROFILE.CurrentUserAllHosts -Parent
    $profileSettingsFile = Join-Path $profileFolder "ProfileSettings.xml"

    $Global:ProfileSettings | Export-Clixml $profileSettingsFile
}

