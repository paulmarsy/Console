function Open-BashPrompt {
    param(
        $Path = $PWD.Path,
        [switch]$InConEmuPane
    )
    
    $argumentList = @(
        "--login"
        "-i"
    ) 
    if ($InConEmuPane) {
        $argumentList += "-new_console:nbs15V:t:`"Bash`":C:`"$($env:ProgramFiles)\Git\mingw64\share\git\git-for-windows.ico`""
    } else {
        $argumentList += "-new_console:nb:t:`"Bash`":C:`"$($env:ProgramFiles)\Git\mingw64\share\git\git-for-windows.ico`""
    }
    
    Start-Process -FilePath (Join-Path $env:ProgramFiles "Git\usr\bin\bash.exe") -ArgumentList $argumentList -WorkingDirectory $Path
}