@(
	@{Name = "Open PowerShell";					Command = """($PowerShellConsoleContstants.Executables.ConEmu)"" /cmd {PowerShell}";					Icon = $conEmuPowerShellIcon; },
	@{Name = "Open PowerShell (No Profile)";	Command = """($PowerShellConsoleContstants.Executables.ConEmu_"" /cmd {PowerShell (No Profile)}";		Icon = $conEmuPowerShellIcon; },
	@{Name = "Open PowerShell (Administrator)";	Command = """($PowerShellConsoleContstants.Executables.ConEmu)"" /cmd {PowerShell (Administrator)}";	Icon = $conEmuPowerShellIcon; },
	@{Name = "Open Command";					Command = """($PowerShellConsoleContstants.Executables.ConEmu)"" /cmd {Command}";						Icon = $conEmuCommandIcon; },
	@{Name = "Open Command (Administrator)";	Command = """($PowerShellConsoleContstants.Executables.ConEmu)"" /cmd {Command (Administrator)}";		Icon = $conEmuCommandIcon;}
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