# GitHub Windows - http://windows.github.com/
& (Join-Path $env:LOCALAPPDATA "GitHub\shell.ps1") -SkipSSHSetup
Import-Module posh-git -Global
$GitPromptSettings.EnableWindowTitle = "Windows PowerShell - Git - "
Enable-GitColors
Start-SshAgent -Quiet
Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -SupportEvent -Action {
    Stop-SshAgent
}