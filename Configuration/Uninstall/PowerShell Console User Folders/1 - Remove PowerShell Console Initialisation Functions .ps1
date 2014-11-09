$initFile = Join-Path $PowerShellConsoleContstants.UserFolders.AppSettingsFolder "Init.ps1"
$enabledFlagFile = Join-Path $PowerShellConsoleContstants.UserFolders.AppSettingsFolder "PowerShellConsole.Enabled.status"
$disabledFlagFile = Join-Path $PowerShellConsoleContstants.UserFolders.AppSettingsFolder "PowerShellConsole.Disabled.status"

Invoke-InstallStep "Removing Initialisation Functions" {
	if (Test-Path $PowerShellConsoleContstants.UserFolders.AppSettingsFunctionsFolder) {
		Remove-Item $PowerShellConsoleContstants.UserFolders.AppSettingsFunctionsFolder -Force -Recurse
	}
	if (Test-Path $initFile) {
		Remove-Item $initFile -Force
	}
}

Invoke-InstallStep "Setting PowerShell Console disabled flag" {
	Set-Content -Path $disabledFlagFile -Value $null
	if (Test-Path $enabledFlagFile) {
		Remove-Item $enabledFlagFile -Force
	}
}