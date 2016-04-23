Invoke-InstallStep "Removing Visual Studio Code Editor Integration" {
	if (Test-Path "HKCU:\Software\Classes\*\shell\Visual Studio Code") {
		Remove-Item "HKCU:\Software\Classes\*\shell\Visual Studio Code" -Recurse -Force
	}
	if(Test-Path "HKCU:\Software\Classes\Directory\Background\shell\Visual Studio Code") {
		Remove-Item "HKCU:\Software\Classes\Directory\Background\shell\Visual Studio Code" -Recurse -Force
	}
	if (Test-Path "HKCU:\Software\Classes\Folder\shell\Visual Studio Code") {
		Remove-Item "HKCU:\Software\Classes\Folder\shell\Visual Studio Code" -Recurse -Force
	}
	if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe"){
		Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" -Force
	}
}

Invoke-InstallStep "Removing Visual Studio Code Start Shortcut" {
	$codeShortcut = Join-Path ([Environment]::GetFolderPath("StartMenu")) "Visual Studio Code.lnk"
	if (Test-Path $codeShortcut) {
		Remove-Item -Path $codeShortcut -Force
	}
}