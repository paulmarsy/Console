function Edit-CustomTextEditor {
    [CmdletBinding()]
    param(
        $Path = $PWD,
        [switch]$CreateFile,
        [ValidateSet("Atom", "Code", "Default")]$Editor = "Default"
    )
    
    if ([System.IO.Path]::IsPathRooted($Path)) {
        $Path = Get-AbsolutePath -Path $Path
    } else {
        $Path = Get-AbsolutePath -Path (Join-Path -Path $PWD -ChildPath $Path)
    }
    
    if ($CreateFile -and -not (Test-Path -Path $Path -PathType Leaf)) {
        Set-File -Path $Path
    }
    
    $editorExe = $null
    switch ($PSCmdlet | % MyInvocation | % InvocationName) {
        "atom" { $editorExe = _Get-CustomTextEditor -Editor "atom" }
        "code"  { $editorExe = _Get-CustomTextEditor -Editor "code" }
        default { $editorExe = _Get-CustomTextEditor -Editor $Editor }
    }
    
    # Hack to supress atom's console output as redirecting output streams and other methods don't seem to work
    Start-Job -ScriptBlock {
        param($EditorExe, $Path)
        Start-Process -FilePath $EditorExe -ArgumentList "`"$Path`""
    } -ArgumentList @($editorExe, $Path) | Wait-Job | Remove-Job
}