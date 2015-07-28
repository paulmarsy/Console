function Get-WindowsTime {
    Write-Host -ForegroundColor Green "`tStatus:"
    Start-Process -FilePath "w32tm.exe" -ArgumentList "/query /status /verbose" -NoNewWindow -Wait
    Write-Host
    Write-Host -ForegroundColor Green "`tPeers:"
    Start-Process -FilePath "w32tm.exe" -ArgumentList "/query /peers /verbose" -NoNewWindow -Wait
}