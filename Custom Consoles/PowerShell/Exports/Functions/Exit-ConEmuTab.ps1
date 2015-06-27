function Exit-ConEmuTab {
    Start-Process -FilePath $PowerShellConsoleConstants.Executables.ConEmuC -ArgumentList "-GuiMacro Close(7)" -Wait -WindowStyle Hidden
    Get-Host | % SetShouldExit 0
}