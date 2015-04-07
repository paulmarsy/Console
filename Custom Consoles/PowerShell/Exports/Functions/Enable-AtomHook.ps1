function Enable-AtomHook {
    Write-Host -NoNewLine "Installing Atom hook... "
    $notepadHijackHelper = Join-Path $ProfileConfig.Module.InstallPath "Libraries\Custom Helper Apps\NotepadHijackHelper\NotepadHijackHelper.exe"
    $atomExecutable = Join-Path $ProfileConfig.Module.InstallPath "Libraries\Atom\App\atom.exe"
    New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" -Force | Out-Null
    New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" "Debugger" -Value """$notepadHijackHelper"" ""$atomExecutable""" -Type String -Force | Out-Null
    Write-Host -ForegroundColor Green "Done"
}