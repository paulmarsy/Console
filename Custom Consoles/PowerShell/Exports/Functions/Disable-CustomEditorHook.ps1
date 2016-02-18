function Disable-CustomEditorHook {
    Write-Host -NoNewLine "Removing custom editor hook... "
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" -Force
    Write-Host -ForegroundColor Green "Done"
}