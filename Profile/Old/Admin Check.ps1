$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity
$elevatedAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)




if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host -ForegroundColor Red "Error! Administrator/UAC Elevation required"
    exit 1
} else {
    Write-Host -ForegroundColor Green "Error! Requires Administrator privileges"
    exit 0
}