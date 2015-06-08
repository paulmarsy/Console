function Open-CommandPrompt {
    param(
        $Path = $PWD.Path,
        [switch]$InConEmuPane
    )
    
    $argumentList = @(
        "/K CD `"$Path`""
    ) 
    if ($InConEmuPane) {
        $argumentList += "-new_console:nbs25V:t:`"Command`""
    }
    
    Start-Process -FilePath $Env:ComSpec -ArgumentList $argumentList
}