function Get-LastWin32ErrorMessage
{
     (New-Object System.ComponentModel.Win32Exception ([System.Runtime.InteropServices.Marshal]::GetLastWin32Error())).Message 
}