function Clear-PowerShellHistory {
    Get-PSReadlineOption | % HistorySavePath | Remove-Item -Force
    Microsoft.PowerShell.Core\Clear-History
}