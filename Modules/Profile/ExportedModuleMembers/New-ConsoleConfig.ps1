function New-ConsoleConfig {    
    $Global:ConsoleConfig = @{
        ConsoleConfigFile = (Join-Path (Split-Path $PROFILE.CurrentUserAllHosts -Parent) "ConsoleConfig.xml")
        Git = @{
            Name        = "Your Name"
            Email       = "email@example.com"
            IgnoreCase  = $True
            DiffRenames = $True
        }
    }

    $Global:ConsoleConfig
}