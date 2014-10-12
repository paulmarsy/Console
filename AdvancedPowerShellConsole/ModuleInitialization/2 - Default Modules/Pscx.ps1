# PowerShell Community Extensions - http://pscx.codeplex.com/
Import-Module Pscx -Global -ArgumentList @{
    TextEditor = (Join-Path $InstallPath "Third Party\Sublime Text\sublime_text.exe")
    CD_EchoNewLocation = $false
}