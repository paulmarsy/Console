function Exit-ConEmuTab {
    $tempOutputFile = Get-TempFile -Path ConsoleTempDirectory
    Start-Process -FilePath $PowerShellConsoleConstants.Executables.ConEmuC -ArgumentList "-GuiMacro Close(7) -GuiMacro Shell(`"open`",`"cmd.exe`",`"/C DEL /Q `"$tempOutputFile`"`")" -Wait -NoNewWindow -RedirectStandardOutput $tempOutputFile
    [System.Environment]::Exit(0)
}