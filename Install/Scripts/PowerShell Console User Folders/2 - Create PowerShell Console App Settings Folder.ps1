Invoke-InstallStep "Creating App Settings Folders" {
	if (-not (Test-Path $PowerShellConsoleContstants.UserFolders.AppSettingsFolder)) {
		New-Item $PowerShellConsoleContstants.UserFolders.AppSettingsFolder -Type Directory -Force | Out-Null
	}
	(Get-Item $PowerShellConsoleContstants.UserFolders.AppSettingsFolder -Force).Attributes = 'Hidden'
}

$initFile = Join-Path $PowerShellConsoleContstants.UserFolders.AppSettingsFolder "Init.ps1"
$enabledFlagFile = Join-Path $PowerShellConsoleContstants.UserFolders.AppSettingsFolder "PowerShellConsole.Enabled.status"
$disabledFlagFile = Join-Path $PowerShellConsoleContstants.UserFolders.AppSettingsFolder "PowerShellConsole.Disabled.status"

Invoke-InstallStep "Creating Initialisation Functions" {
	if (Test-Path $PowerShellConsoleContstants.UserFolders.AppSettingsFunctionsFolder) {
		Remove-Item $PowerShellConsoleContstants.UserFolders.AppSettingsFunctionsFolder -Force -Recurse
	}
	New-Item $PowerShellConsoleContstants.UserFolders.AppSettingsFunctionsFolder -Type Directory -Force | Out-Null
	Copy-Item -Path ".\Init Functions\*" -Destination $PowerShellConsoleContstants.UserFolders.AppSettingsFunctionsFolder -Force -Recurse

	New-Item $initFile -Type File -Force | Out-Null
	Set-Content -Path $initFile -Value `
@"
Get-ChildItem -Path "$($PowerShellConsoleContstants.UserFolders.AppSettingsFunctionsFolder)" -Filter "*.ps1" | % { . "`$(`$_.FullName)" }

Start-PowerShellConsole
"@
}

Invoke-InstallStep "Tokenizing Initialisation Functions" {
	$tokenTable = @{
		PowerShellConsoleEnabledFlagFile = $enabledFlagFile
		PowerShellConsoleDisabledFlagFile = $disabledFlagFile
		HStartPath = (Join-Path $PowerShellConsoleContstants.InstallPath "Third Party\Binaries\hstart64.exe")
		InternalInstallFile = (Join-Path $PowerShellConsoleContstants.InstallPath "Install\Scripts\InternalInstall.bat")
		ConEmuExecutablePath = $PowerShellConsoleContstants.Executables.ConEmu
		InstallPath = $PowerShellConsoleContstants.InstallPath
		PowerShellConsoleModulePath = (Join-Path $PowerShellConsoleContstants.InstallPath "PowerShellConsole")
	}
	Get-ChildItem -Path $PowerShellConsoleContstants.UserFolders.AppSettingsFunctionsFolder -Filter *.ps1 | % {
		$functionText = [System.IO.File]::ReadAllText($_.FullName)
		$tokenTable.GetEnumerator() | % {
			$token = "##$($_.Name)##"
			$value = $_.Value
			$functionText = $functionText.Replace($token, $value)
		}
		[System.IO.File]::WriteAllText($_.FullName, $functionText)
	}
}

Invoke-InstallStep "Setting PowerShell Console enabled flag" {
	Set-Content -Path $enabledFlagFile -Value $null
	if (Test-Path $disabledFlagFile) {
		Remove-Item $disabledFlagFile -Force
	}
}