function Enable-CustomEditorHook {
    Write-Host -NoNewLine "Installing Visual Studio Code custom editor hook... "
    
    $notepadHijackHelper = Join-Path $ProfileConfig.Module.InstallPath "Libraries\Custom Helper Apps\NotepadHijackHelper\NotepadHijackHelper.exe"
    
    $editorExe =  $PowerShellConsoleConstants.Executables.VisualStudioCode 

    New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" -Force | Out-Null
    New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" "Debugger" -Value """$notepadHijackHelper"" ""$editorExe""" -Type String -Force | Out-Null
    Write-Host -ForegroundColor Green "Done"
}
