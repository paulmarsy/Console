function Open-FarManager {
    param(
        $ActivePath = $PWD.Path,
        $PassivePath = $ProfileConfig.General.UserFolder
    )
    
    $argumentList = @(
        "-w"
        ("-p`"{0};{1}`"" -f (Join-Path $ProfileConfig.Module.InstallPath "Libraries\ConEmu\Plugins"), (Join-Path $ProfileConfig.Module.InstallPath "Libraries\Far\Plugins"))
        "`"$ActivePath`""
        "`"$PassivePath`""
    ) 
    Start-Process -FilePath (Join-Path $ProfileConfig.Module.InstallPath "Libraries\Far\Far.exe") -ArgumentList $argumentList
}