function Disable-AtomHook {
    Write-Host -NoNewLine "Removing Atom hook... "
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" -Force
    Write-Host -ForegroundColor Green "Done"
}