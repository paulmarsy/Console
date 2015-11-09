function _Get-CustomTextEditor {
    param(
        [ValidateSet("Atom", "Code", "Default")]$Editor = "Default"
    )
    
    $editorExe = $null
    switch ($Editor) {
        "Atom" { $editorExe = $PowerShellConsoleConstants.Executables.Atom }
        "Code"  { $editorExe = $PowerShellConsoleConstants.Executables.VisualStudioCode }
        default {
            switch ($ProfileConfig.PowerShell.CustomTextEditor) {
                "Atom" { $editorExe = $PowerShellConsoleConstants.Executables.Atom }
                "Code"  { $editorExe = $PowerShellConsoleConstants.Executables.VisualStudioCode }
                default { $editorExe = $PowerShellConsoleConstants.Executables.Atom } 
            }
        }
    }
    
    return $editorExe
}