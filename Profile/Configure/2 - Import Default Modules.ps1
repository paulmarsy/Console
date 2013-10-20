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
& (Join-Path $env:LOCALAPPDATA "GitHub\shell.ps1") -SkipSSHSetup
Import-Module posh-git -Global
$GitPromptSettings.EnableWindowTitle = "Windows PowerShell - Git - "
Enable-GitColors
Start-SshAgent -Quiet

# Microsoft Team Foundation Server 2013 Power Tools
Import-Module (Join-Path $env:TFSPowerToolDir "Microsoft.TeamFoundation.PowerTools.PowerShell.dll") -Global