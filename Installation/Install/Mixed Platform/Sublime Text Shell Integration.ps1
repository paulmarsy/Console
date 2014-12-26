$sublimeTextExecutable = $PowerShellConsoleConstants.Executables.SublimeText
$sublimeTextShortcut = Join-Path ([Environment]::GetFolderPath("StartMenu")) "Sublime Text.lnk"

Invoke-InstallStep "Configuring Sublime Text Shell Integration" {
	$sublimeLauncher = Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Sublime Text\SublimeLauncher.exe"
	$sublimeIcon = "$($sublimeTextExecutable),0"

	New-Item "HKCU:\Software\Classes\*\shell\Sublime Text" -Force | Out-Null
	New-ItemProperty -LiteralPath "HKCU:\Software\Classes\*\shell\Sublime Text" "Icon" -Value "$sublimeIcon" -Type String -Force | Out-Null
	New-Item "HKCU:\Software\Classes\*\shell\Sublime Text\command" -Value """$sublimeTextExecutable"" ""%L""" -Type String -Force | Out-Null

	New-Item "HKCU:\Software\Classes\Directory\Background\shell\Sublime Text" -Force | Out-Null
	New-ItemProperty -LiteralPath "HKCU:\Software\Classes\Directory\Background\shell\Sublime Text" "Icon" -Value "$sublimeIcon" -Type String -Force | Out-Null
	New-Item "HKCU:\Software\Classes\Directory\Background\shell\Sublime Text\command" -Value """$sublimeTextExecutable"" ""%V""" -Type String -Force | Out-Null

	New-Item "HKCU:\Software\Classes\Folder\shell\Sublime Text" -Force | Out-Null
	New-ItemProperty -LiteralPath "HKCU:\Software\Classes\Folder\shell\Sublime Text" "Icon" -Value "$sublimeIcon" -Type String -Force | Out-Null
	New-Item "HKCU:\Software\Classes\Folder\shell\Sublime Text\command" -Value """$sublimeTextExecutable"" ""%L""" -Type String -Force | Out-Null

	New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" -Force | Out-Null
	New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" "Debugger" -Value """$sublimeLauncher"" -z" -Type String -Force | Out-Null
}

Invoke-InstallStep "Setting up Sublime Text Start Shortcut" {
	$WshShell = New-Object -ComObject WScript.Shell
	$consoleShortcut = $WshShell.CreateShortcut($sublimeTextShortcut)
	$consoleShortcut.TargetPath = $sublimeTextExecutable
	$consoleShortcut.IconLocation = $sublimeTextExecutable
	$consoleShortcut.Save()
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null
}