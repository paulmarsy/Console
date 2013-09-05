param($InstallPath)

"Configuring Sublime Text Explorer Integration..."
New-Item "HKCU:\Software\Classes\*\shell\Sublime Text" -Force | Out-Null
New-ItemProperty "HKCU:\Software\Classes\*\shell\Sublime Text" "Icon" -Value "$InstallPath\Sublime Text\sublime_text.exe,0" -Type String -Force | Out-Null
New-Item "HKCU:\Software\Classes\*\shell\Sublime Text\command" -Value """$InstallPath\Sublime Text\sublime_text.exe"" ""%L""" -Type String -Force | Out-Null

New-Item "HKCU:\Software\Classes\Folder\shell\Sublime Text" -Force | Out-Null
New-ItemProperty "HKCU:\Software\Classes\Folder\shell\Sublime Text" "Icon" -Value "$InstallPath\Sublime Text\sublime_text.exe,0" -Type String -Force | Out-Null
New-Item "HKCU:\Software\Classes\Folder\shell\Sublime Text\command" -Value """$InstallPath\Sublime Text\sublime_text.exe"" ""%L""" -Type String -Force | Out-Null

New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" -Force | Out-Null
New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Notepad.exe" "Debugger" -Value """$InstallPath\Sublime Text\SublimeLauncher.exe"" -z" -Type String -Force | Out-Null