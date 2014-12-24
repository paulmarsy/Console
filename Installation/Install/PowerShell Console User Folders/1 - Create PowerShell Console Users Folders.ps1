Invoke-InstallStep "Creating Users Folder" {
	if (Test-Path $PowerShellConsoleConstants.UserFolders.Root) {
		$userFolder = Get-Item -Path $PowerShellConsoleConstants.UserFolders.Root -Force
	}
	else {
		$userFolder = New-Item -Path $PowerShellConsoleConstants.UserFolders.Root -Type Directory -Force
	}

	$userFolder.Attributes = @([System.IO.FileAttributes]::ReadOnly, [System.IO.FileAttributes]::System)
}

Invoke-InstallStep "Customising Users Folder's appearance" {
	$desktopIniPath = Join-Path $PowerShellConsoleConstants.UserFolders.Root "desktop.ini"
	if (Test-Path $desktopIniPath) {
		$existingDesktopIniFile = Get-Item -Path $desktopIniPath -Force
		$existingDesktopIniFile.Attributes = [System.IO.FileAttributes]::Normal
		Remove-Item -Path $existingDesktopIniFile -Force
	}
	Copy-Item -Path (Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Resources\PowerShellUserFolder-desktop.ini") -Destination $desktopIniPath -Force

	$desktopIniText = [System.IO.File]::ReadAllText($desktopIniPath)
	$desktopIniText = $desktopIniText.Replace("##InstallPath##", $PowerShellConsoleConstants.InstallPath)
	[System.IO.File]::WriteAllText($desktopIniPath, $desktopIniText)

	$desktopIniFile = Get-Item -Path $desktopIniPath -Force
	$desktopIniFile.Attributes = @([System.IO.FileAttributes]::ReadOnly, [System.IO.FileAttributes]::System, [System.IO.FileAttributes]::Hidden)
}