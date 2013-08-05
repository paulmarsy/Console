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

# GitHub Windows - http://windows.github.com/
& (Join-Path $env:LOCALAPPDATA "GitHub\shell.ps1")
Import-Module (Join-Path $env:github_posh_git "posh-git.psm1") -Global
$GitPromptSettings.EnableWindowTitle = "Windows PowerShell - Git - "
Enable-GitColors
Start-SshAgent -Quiet