$atomExecutable = $PowerShellConsoleConstants.Executables.Atom
$atomShortcut = Join-Path ([Environment]::GetFolderPath("StartMenu")) "Atom.lnk"

Invoke-InstallStep "Configuring Atom Editor Integration" {
	$atomIcon = "$($atomExecutable),0"

	$notepadHijackHelper = Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Custom Helper Apps\NotepadHijackHelper\NotepadHijackHelper.exe"

	New-Item "HKCU:\Software\Classes\*\shell\Atom Editor" -Force | Out-Null
	New-ItemProperty -LiteralPath "HKCU:\Software\Classes\*\shell\Atom Editor" "Icon" -Value "$atomIcon" -Type String -Force | Out-Null
	New-Item "HKCU:\Software\Classes\*\shell\Atom Editor\command" -Value """$atomExecutable"" ""%L""" -Type String -Force | Out-Null

	New-Item "HKCU:\Software\Classes\Directory\Background\shell\Atom Editor" -Force | Out-Null
	New-ItemProperty -LiteralPath "HKCU:\Software\Classes\Directory\Background\shell\Atom Editor" "Icon" -Value "$atomIcon" -Type String -Force | Out-Null
	New-Item "HKCU:\Software\Classes\Directory\Background\shell\Atom Editor\command" -Value """$atomExecutable"" ""%V""" -Type String -Force | Out-Null

	New-Item "HKCU:\Software\Classes\Folder\shell\Atom Editor" -Force | Out-Null
	New-ItemProperty -LiteralPath "HKCU:\Software\Classes\Folder\shell\Atom Editor" "Icon" -Value "$atomIcon" -Type String -Force | Out-Null
	New-Item "HKCU:\Software\Classes\Folder\shell\Atom Editor\command" -Value """$atomExecutable"" ""%L""" -Type String -Force | Out-Null

	New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" -Force | Out-Null
	New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" "Debugger" -Value """$notepadHijackHelper"" ""$atomExecutable""" -Type String -Force | Out-Null
}

Invoke-InstallStep "Setting up Atom Editor Start Shortcut" {
	$WshShell = New-Object -ComObject WScript.Shell
	$consoleShortcut = $WshShell.CreateShortcut($atomShortcut)
	$consoleShortcut.TargetPath = $atomExecutable
	$consoleShortcut.IconLocation = $atomExecutable
	$consoleShortcut.Save()
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null
}