# PowerShell Community Extensions - http://pscx.codeplex.com/
Import-Module Pscx -Global -ArgumentList @{
    TextEditor = "$InstallPath\Sublime Text\sublime_text.exe";
    CD_EchoNewLocation = $false
}

# Carbon - PowerShell DevOps module - http://get-carbon.org/
Import-Module Carbon -Global

# PSReadline - https://github.com/lzybkr/PSReadLine
if ($host.Name -eq 'ConsoleHost') {
	Import-Module PSReadline -Global
	Set-PSReadlineKeyHandler -Key Ctrl+C -ScriptBlock {}
	Set-PSReadlineKeyHandler -Key Ctrl+V -ScriptBlock {}
}

# GitHub Windows - http://windows.github.com/
& (Join-Path $env:LOCALAPPDATA "GitHub\shell.ps1") -SkipSSHSetup
Import-Module posh-git -Global
$GitPromptSettings.EnableWindowTitle = "Windows PowerShell - Git - "
Enable-GitColors
Start-SshAgent -Quiet

# Microsoft Team Foundation Server 2013 Power Tools
Import-Module (Join-Path $env:TFSPowerToolDir "Microsoft.TeamFoundation.PowerTools.PowerShell.dll") -Global