param($InstallPath)

# PowerShell Community Extensions - http://pscx.codeplex.com/
Import-Module Pscx -Global -ArgumentList @{
    TextEditor = "$InstallPath\Sublime Text\sublime_text.exe";
    CD_EchoNewLocation = $false
}

# Carbon - PowerShell DevOps module - http://get-carbon.org/
Import-Module Carbon -Global

# PowerTab - http://powertab.codeplex.com/
Import-Module PowerTab -Global
$PowerTabConfig.ShowBanner = $false
Export-TabExpansionConfig 