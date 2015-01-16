Invoke-InstallStep "Removing Atom Editor Integration" {
	if (Test-Path "HKCU:\Software\Classes\*\shell\Atom") {
		Remove-Item "HKCU:\Software\Classes\*\shell\Atom" -Recurse -Force
	}
	if(Test-Path "HKCU:\Software\Classes\Directory\Background\shell\Atom") {
		Remove-Item "HKCU:\Software\Classes\Directory\Background\shell\Atom" -Recurse -Force
	}
	if (Test-Path "HKCU:\Software\Classes\Folder\shell\Atom") {
		Remove-Item "HKCU:\Software\Classes\Folder\shell\Atom" -Recurse -Force
	}
	if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe"){
		Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" -Force
	}
}

Invoke-InstallStep "Removing Atom Start Shortcut" {
	$atomShortcut = Join-Path ([Environment]::GetFolderPath("StartMenu")) "Atom.lnk"
	if (Test-Path $atomShortcut) {
		Remove-Item -Path $atomShortcut -Force
	}
}