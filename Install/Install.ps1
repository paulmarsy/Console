if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host -ForegroundColor Red "Error! Requires Administrator privileges"
    return
}

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

& ".\Prerequisites Check.ps1"

#Get-ChildItem .\Configure | % {
#    & $_.FullName -InstallPath $pwd.Path
#}