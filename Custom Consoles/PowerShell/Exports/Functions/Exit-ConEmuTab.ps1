function Exit-ConEmuTab {
    Start-Process -FilePath $PowerShellConsoleConstants.Executables.ConEmuC -ArgumentList "-GuiMacro Close(7)" -Wait -NoNewWindow
    Get-Host | % SetShouldExit 0
}