Invoke-InstallStep "Configuring Sublime Text Shell Integration" {
	$sublimeExecutable = Join-Path $InstallPath "Third Party\Sublime Text\sublime_text.exe"
	$sublimeLauncher = Join-Path $InstallPath "Third Party\Sublime Text\SublimeLauncher.exe"
	$sublimeIcon = Join-Path $InstallPath "Third Party\Sublime Text\sublime_text.exe,0"

	New-Item "HKCU:\Software\Classes\*\shell\Sublime Text" -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Classes\*\shell\Sublime Text" "Icon" -Value "$sublimeIcon" -Type String -Force | Out-Null
	New-Item "HKCU:\Software\Classes\*\shell\Sublime Text\command" -Value """$sublimeExecutable"" ""%L""" -Type String -Force | Out-Null

	New-Item "HKCU:\Software\Classes\Directory\Background\shell\Sublime Text" -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Classes\Directory\Background\shell\Sublime Text" "Icon" -Value "$sublimeIcon" -Type String -Force | Out-Null
	New-Item "HKCU:\Software\Classes\Directory\Background\shell\Sublime Text\command" -Value """$sublimeExecutable"" ""%V""" -Type String -Force | Out-Null

	New-Item "HKCU:\Software\Classes\Folder\shell\Sublime Text" -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Classes\Folder\shell\Sublime Text" "Icon" -Value "$sublimeIcon" -Type String -Force | Out-Null
	New-Item "HKCU:\Software\Classes\Folder\shell\Sublime Text\command" -Value """$sublimeExecutable"" ""%L""" -Type String -Force | Out-Null

	New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" -Force | Out-Null
	New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" "Debugger" -Value """$sublimeLauncher"" -z" -Type String -Force | Out-Null
}

Invoke-InstallStep "Setting up Sublime Text Start Shortcut" {
	$sublimeTextExecutable = Join-Path $InstallPath "Third Party\Sublime Text\sublime_text.exe"

	$WshShell = New-Object -ComObject WScript.Shell
	$consoleShortcut = $WshShell.CreateShortcut((Join-Path ([Environment]::GetFolderPath("StartMenu")) "Sublime Text.lnk"))
	$consoleShortcut.TargetPath = $sublimeTextExecutable
	$consoleShortcut.IconLocation = $sublimeTextExecutable
	$consoleShortcut.Save()
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null
}