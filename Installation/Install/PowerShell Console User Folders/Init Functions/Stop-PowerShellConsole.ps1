function Stop-PowerShellConsole {
	if (Get-Module -Name CustomPowerShellConsole) {
		$tempOutputFile = Get-TempFile -Path ConsoleTempDirectory
		Start-Process -FilePath "##ConEmuCExecutablePath##" -ArgumentList "-GuiMacro:S2 Close(0,1)" -Wait -NoNewWindow -RedirectStandardOutput $tempOutputFile
		Start-Process -FilePath "##ConEmuCExecutablePath##" -ArgumentList "-GuiMacro:S2 Close(0,1)" -Wait -NoNewWindow -RedirectStandardOutput $tempOutputFile
		Remove-Item -Path $tempOutputFile -Force
		Remove-Module CustomPowerShellConsole -Force
	}
}