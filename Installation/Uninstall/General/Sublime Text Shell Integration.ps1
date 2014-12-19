$sublimeTextShortcut = Join-Path ([Environment]::GetFolderPath("StartMenu")) "Sublime Text.lnk"

Invoke-InstallStep "Removing Sublime Text Shell Integration" {
	if (Test-Path "HKCU:\Software\Classes\*\shell\Sublime Text") {
		Remove-Item "HKCU:\Software\Classes\*\shell\Sublime Text" -Recurse -Force
	}
	if(Test-Path "HKCU:\Software\Classes\Directory\Background\shell\Sublime Text") {
		Remove-Item "HKCU:\Software\Classes\Directory\Background\shell\Sublime Text" -Recurse -Force
	}
	if (Test-Path "HKCU:\Software\Classes\Folder\shell\Sublime Text") {
		Remove-Item "HKCU:\Software\Classes\Folder\shell\Sublime Text" -Recurse -Force
	}
	if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe"){
		Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" -Force
	}
}

Invoke-InstallStep "Removing Sublime Text Start Shortcut" {
	if (Test-Path $sublimeTextShortcut) {
		Remove-Item -Path $sublimeTextShortcut -Force
	}
}