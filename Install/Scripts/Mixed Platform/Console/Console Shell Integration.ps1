@(
	@{Name = "Open PowerShell";					Command = """$conEmuExecutable"" /cmd powershell.exe -cur_console:n";	Icon = $conEmuPowerShellIcon; },
	@{Name = "Open PowerShell (Administrator)";	Command = """$conEmuExecutable"" /cmd powershell.exe -cur_console:na";	Icon = $conEmuPowerShellIcon; },
	@{Name = "Open Command";					Command = """$conEmuExecutable"" /cmd cmd.exe -cur_console:n";			Icon = $conEmuCommandIcon; },
	@{Name = "Open Command (Administrator)";	Command = """$conEmuExecutable"" /cmd cmd.exe -cur_console:na";			Icon = $conEmuCommandIcon;}
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