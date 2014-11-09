Import-Module Pscx -Global -ArgumentList @{
    TextEditor = (Join-Path $ConsoleRoot "Libraries\Sublime Text\sublime_text.exe")
    CD_EchoNewLocation = $false
}