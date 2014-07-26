function Get-LastError
{
     (New-Object System.ComponentModel.Win32Exception ([System.Runtime.InteropServices.Marshal]::GetLastWin32Error())).Message 
}