function Edit-InAtom {
    param(
        $Path = $PWD,
        [switch]$CreateFile
    )
    
    if ([System.IO.Path]::IsPathRooted($Path)) {
        $Path = Get-AbsolutePath -Path $Path
    } else {
        $Path = Get-AbsolutePath -Path (Join-Path -Path $PWD -ChildPath $Path)
    }
    
    if ($CreateFile -and -not (Test-Path -Path $Path -PathType Leaf)) {
        Set-File -Path $Path
    }
    
    # Hack to supress atom's console output as redirecting output streams and other methods don't seem to work
    Start-Job -ScriptBlock {
        param($AtomExecutable, $Path)
        Start-Process -FilePath $AtomExecutable -ArgumentList "`"$Path`""
    } -ArgumentList @($PowerShellConsoleConstants.Executables.Atom, $Path) | Wait-Job | Remove-Job
}