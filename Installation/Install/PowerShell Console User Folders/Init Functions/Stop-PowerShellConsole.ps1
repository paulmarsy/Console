function Stop-PowerShellConsole {
	if (Get-Module -Name CustomPowerShellConsole) {
		Start-Process -FilePath "##ConEmuCExecutablePath##" -ArgumentList "-GuiMacro:S2 Close(0,1)" -Wait -WindowStyle Hidden
		Start-Process -FilePath "##ConEmuCExecutablePath##" -ArgumentList "-GuiMacro:S2 Close(0,1)" -Wait -WindowStyle Hidden
		Remove-Module CustomPowerShellConsole -Force
	}
}