$initFile = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "Init.ps1"
$enabledFlagFile = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "PowerShellConsole.Enabled.status"
$disabledFlagFile = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "PowerShellConsole.Disabled.status"

Invoke-InstallStep "Removing Initialisation Functions" {
	if (Test-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFunctionsFolder) {
		Remove-Item $PowerShellConsoleConstants.UserFolders.AppSettingsFunctionsFolder -Force -Recurse
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