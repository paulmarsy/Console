function Open-CommandPrompt {
    param(
        $Path = $PWD.Path,
        [switch]$InConEmuPane
    )
    
    $argumentList = @() 
    if ($InConEmuPane) {
        $argumentList += "-new_console:nbs15V:t:`"Command`""
    } else {
        $argumentList += "-new_console:nb:t:`"Command`""
    }
    
    Start-Process -FilePath $Env:ComSpec -ArgumentList $argumentList -WorkingDirectory $Path
}