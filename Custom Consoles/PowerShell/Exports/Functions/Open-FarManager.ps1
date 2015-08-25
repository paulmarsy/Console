function Open-FarManager {
    param(
        $Path = $PWD.Path,
        [switch]$InConEmuPane
    )
    
    $argumentList = @(
        "-w"
        ("-t `"{0}`"" -f (Join-Path $ProfileConfig.Module.InstallPath "Libraries\Resources\Far.config"))
        ("-p`"{0};{1}`"" -f (Join-Path $ProfileConfig.Module.InstallPath "Libraries\ConEmu\Plugins"), (Join-Path $ProfileConfig.Module.InstallPath "Libraries\Far\Plugins"))
        "`"$Path`""
    ) 
    if ($InConEmuPane) {
        $argumentList += "-new_console:nbs40H:h0"
    } else {
        $argumentList += "-new_console:nb:h0"
    }
    
    Start-Process -FilePath (Join-Path $ProfileConfig.Module.InstallPath "Libraries\Far\Far.exe") -ArgumentList $argumentList -WorkingDirectory $Path
}