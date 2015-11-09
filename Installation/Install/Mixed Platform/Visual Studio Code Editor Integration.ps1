$visualStudioCodeExecutable = $PowerShellConsoleConstants.Executables.VisualStudioCode
$visualStudioCodeShortcut = Join-Path ([Environment]::GetFolderPath("StartMenu")) "Visual Studio Code.lnk"

Invoke-InstallStep "Configuring Visual Studio Code Integration" {
	$visualStudioCodeIcon = "$($visualStudioCodeExecutable),0"

	$notepadHijackHelper = Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Custom Helper Apps\NotepadHijackHelper\NotepadHijackHelper.exe"

	New-Item "HKCU:\Software\Classes\*\shell\Visual Studio Code" -Force | Out-Null
	New-ItemProperty -LiteralPath "HKCU:\Software\Classes\*\shell\Visual Studio Code" "Icon" -Value "$visualStudioCodeIcon" -Type String -Force | Out-Null
	New-Item "HKCU:\Software\Classes\*\shell\Visual Studio Code\command" -Value """$visualStudioCodeExecutable"" ""%L""" -Type String -Force | Out-Null

	New-Item "HKCU:\Software\Classes\Directory\Background\shell\Visual Studio Code" -Force | Out-Null
	New-ItemProperty -LiteralPath "HKCU:\Software\Classes\Directory\Background\shell\Visual Studio Code" "Icon" -Value "$visualStudioCodeIcon" -Type String -Force | Out-Null
	New-Item "HKCU:\Software\Classes\Directory\Background\shell\Visual Studio Code\command" -Value """$visualStudioCodeExecutable"" ""%V""" -Type String -Force | Out-Null

	New-Item "HKCU:\Software\Classes\Folder\shell\Visual Studio Code" -Force | Out-Null
	New-ItemProperty -LiteralPath "HKCU:\Software\Classes\Folder\shell\Visual Studio Code" "Icon" -Value "$visualStudioCodeIcon" -Type String -Force | Out-Null
	New-Item "HKCU:\Software\Classes\Folder\shell\Visual Studio Code\command" -Value """$visualStudioCodeExecutable"" ""%L""" -Type String -Force | Out-Null
}

Invoke-InstallStep "Setting up Visual Studio Code Start Shortcut" {
	$WshShell = New-Object -ComObject WScript.Shell
	$consoleShortcut = $WshShell.CreateShortcut($visualStudioCodeShortcut)
	$consoleShortcut.TargetPath = $visualStudioCodeExecutable
	$consoleShortcut.IconLocation = $visualStudioCodeExecutable
	$consoleShortcut.Save()
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null
}