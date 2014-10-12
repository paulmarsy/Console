@(
	@{Name = "Open PowerShell";					Command = """$conEmuExecutable"" /cmd {PowerShell}";					Icon = $conEmuPowerShellIcon; },
	@{Name = "Open PowerShell (No Profile)";	Command = """$conEmuExecutable"" /cmd {PowerShell (No Profile)}";		Icon = $conEmuPowerShellIcon; },
	@{Name = "Open PowerShell (Administrator)";	Command = """$conEmuExecutable"" /cmd {PowerShell (Administrator)}";	Icon = $conEmuPowerShellIcon; },
	@{Name = "Open Command";					Command = """$conEmuExecutable"" /cmd {Command}";						Icon = $conEmuCommandIcon; },
	@{Name = "Open Command (Administrator)";	Command = """$conEmuExecutable"" /cmd {Command (Administrator)}";		Icon = $conEmuCommandIcon;}
) | % {
	$link = $_
	Invoke-InstallStep "Configuring '$($link.Name)' Shell Integration" {
		@("*", "Directory\Background", "Folder", "Drive") | % { 
			New-Item "HKCU:\Software\Classes\$_\shell\$($link.Name)" -Force | Out-Null
			New-ItemProperty "HKCU:\Software\Classes\$_\shell\$($link.Name)" "Icon" -Value $link.Icon -Type String -Force | Out-Null
			New-Item "HKCU:\Software\Classes\$_\shell\$($link.Name)\command" -Value $link.Command -Type String -Force | Out-Null
		}
	}
}