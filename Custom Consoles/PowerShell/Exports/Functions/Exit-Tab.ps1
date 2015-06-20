function Exit-Tab {
    Start-Process -FilePath $PowerShellConsoleConstants.Executables.ConEmuC -ArgumentList "-GuiMacro Close(7)" -Wait -NoNewWindow
}