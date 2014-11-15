$linksFolder = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Name "{BFB9D5E0-C6A9-404C-B2B2-AE6DB6AF4968}" | % "{BFB9D5E0-C6A9-404C-B2B2-AE6DB6AF4968}"
$shortcutPath = Join-Path $linksFolder "PowerShell Console.lnk"

Invoke-InstallStep "Adding PowerShell Consoler User Folder to Links folder" {
	$WshShell = New-Object -ComObject WScript.Shell
	$consoleShortcut = $WshShell.CreateShortcut($shortcutPath)
	$consoleShortcut.TargetPath = $PowerShellConsoleContstants.UserFolders.Root
	$consoleShortcut.Save()
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null
}