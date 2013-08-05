function Export-ProfileConfig {    
    $profileSettingsFile = Join-Path (Split-Path $PROFILE.CurrentUserAllHosts -Parent) "ProfileSettings.xml"

    $ProfileSettings | Export-Clixml $profileSettingsFile
}