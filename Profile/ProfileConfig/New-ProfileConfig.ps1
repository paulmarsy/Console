function New-ProfileConfig {   
    param($overrideProfileConfig)

    $ProfileConfig = @{
        General = @{
            InstallPath         = $InstallPath
            ProfileConfigFile   = $profileConfigFile
        }
        Git = @{
            Name                = $(if ($overrideProfileConfig.Git.Name)     { $overrideProfileConfig.Git.Name }     else { "Your Name" })
            Email               = $(if ($overrideProfileConfig.Git.Email)    { $overrideProfileConfig.Git.Email }    else { "email@example.com" })
        }
        TFS = @{
            Server              = $(if ($overrideProfileConfig.TFS.Server)   { $overrideProfileConfig.TFS.Server }   else { "Your TFS Server URL" })
        }
    }

    $ProfileConfig
}