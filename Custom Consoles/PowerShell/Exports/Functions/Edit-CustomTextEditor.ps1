function Edit-CustomTextEditor {
    [CmdletBinding()]
    param(
        [string]$Path = $PWD.ProviderPath,
        [switch]$CreateFile
    )
    
    if ([System.IO.Path]::IsPathRooted($Path)) {
        $Path = Get-AbsolutePath -Path $Path
    } else {
        $Path = Get-AbsolutePath -Path (Join-Path -Path $PWD.ProviderPath -ChildPath $Path)
    }
    
    if ($CreateFile -and -not (Test-Path -Path $Path -PathType Leaf)) {
        Set-File -Path $Path
    }    

    # Hack to supress atom's console output as redirecting output streams and other methods don't seem to work
    Start-Job -ScriptBlock {
        param($VisualStudioCode, $Path)
        Start-Process -FilePath $VisualStudioCode -ArgumentList "`"$Path`""
    } -ArgumentList @($PowerShellConsoleConstants.Executables.VisualStudioCode, $Path) | Wait-Job | Remove-Job
}