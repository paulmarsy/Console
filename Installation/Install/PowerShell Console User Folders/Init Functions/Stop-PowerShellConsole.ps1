function Stop-PowerShellConsole {
	if (Get-Module -Name CustomPowerShellConsole) {
		Start-Process -FilePath "##ConEmuCExecutablePath##" -ArgumentList "-GuiMacro:S2 Close(0,1)" -Wait -NoNewWindow
		Start-Process -FilePath "##ConEmuCExecutablePath##" -ArgumentList "-GuiMacro:S2 Close(0,1)" -Wait -NoNewWindow
		Remove-Module CustomPowerShellConsole -Force
	}
}