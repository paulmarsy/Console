function Enable-CustomEditorHook {
    [CmdletBinding()]
    param(
        [ValidateSet("Atom", "Code", "Default")]$Editor = "Default"
    )
    
    Write-Host -NoNewLine "Installing $Editor custom editor hook... "
    
    $notepadHijackHelper = Join-Path $ProfileConfig.Module.InstallPath "Libraries\Custom Helper Apps\NotepadHijackHelper\NotepadHijackHelper.exe"
    
    $editorExe = $null
    switch ($PSCmdlet | % MyInvocation | % InvocationName) {
        "atom" { $editorExe = _Get-CustomTextEditor -Editor "atom" }
        "code"  { $editorExe = _Get-CustomTextEditor -Editor "code" }
        default { $editorExe = _Get-CustomTextEditor -Editor $Editor }
    }

    New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" -Force | Out-Null
    New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" "Debugger" -Value """$notepadHijackHelper"" ""$editorExe""" -Type String -Force | Out-Null
    Write-Host -ForegroundColor Green "Done"
}
