function New-ConsoleConfig {   
    param($storedConsoleConfig)

    $Global:ConsoleConfig = @{
        ConsoleConfigFile = ?? $storedConsoleConfig.ConsoleConfigFile (Join-Path (Split-Path $PROFILE.CurrentUserAllHosts -Parent) "ConsoleConfig.xml")
        Git = @{
            Name        = ?? $storedConsoleConfig.Git.Name "Your Name"
            Email       = ?? $storedConsoleConfig.Git.Email "email@example.com"
            IgnoreCase  = ?? $storedConsoleConfig.Git.IgnoreCase $True
            DiffRenames = ?? $storedConsoleConfig.Git.DiffRenames $True
        }
        TFS = @{
            Server      = ?? $storedConsoleConfig.TFS.Server "TFS Server URL"
        }
    }

    $Global:ConsoleConfig
}