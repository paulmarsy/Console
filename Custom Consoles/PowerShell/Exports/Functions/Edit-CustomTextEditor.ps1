function Edit-CustomTextEditor {
    [CmdletBinding()]
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

    Start-Process -FilePath $PowerShellConsoleConstants.Executables.VisualStudioCode -ArgumentList "`"$Path`""
}