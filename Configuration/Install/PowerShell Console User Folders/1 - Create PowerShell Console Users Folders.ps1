Invoke-InstallStep "Creating Users Folder" {
	if (Test-Path $PowerShellConsoleContstants.UserFolders.Root) {
		$userFolder = Get-Item $PowerShellConsoleContstants.UserFolders.Root -Force
	}
	else {
		$userFolder = New-Item $PowerShellConsoleContstants.UserFolders.Root -Type Directory -Force
	}

	$userFolder.Attributes = @([System.IO.FileAttributes]::ReadOnly,[System.IO.FileAttributes]::System)
}

Invoke-InstallStep "Customising Users Folder's appearance" {
	$desktopIniFile = $PowerShellConsoleContstants.UserFolders.Root desktop.ini
	Copy-Item -Path (Join-Path $PowerShellConsoleContstants.ConsoleRoot "Libraries\Icons\PowerShellUserFolder-desktop.ini") -Destination $desktopIniFile -Force

	$desktopIniText = [System.IO.File]::ReadAllText($desktopIniFile)
	$desktopIniText = $desktopIniText.Replace("##InstallPath##", $PowerShellConsoleContstants.InstallPath)
	[System.IO.File]::WriteAllText($desktopIniFilee, $desktopIniText)
}