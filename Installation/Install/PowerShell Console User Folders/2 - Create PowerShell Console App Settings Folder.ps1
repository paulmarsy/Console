Invoke-InstallStep "Creating App Settings Folders" {
	if (-not (Test-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder)) {
		New-Item $PowerShellConsoleConstants.UserFolders.AppSettingsFolder -Type Directory -Force | Out-Null
	}
	(Get-Item $PowerShellConsoleConstants.UserFolders.AppSettingsFolder -Force).Attributes = 'Hidden'
}

$initFile = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "Init.ps1"
$enabledFlagFile = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "PowerShellConsole.Enabled.status"
$disabledFlagFile = Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder "PowerShellConsole.Disabled.status"

Invoke-InstallStep "Creating Initialisation Functions" {
	if (Test-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFunctionsFolder) {
		Remove-Item $PowerShellConsoleConstants.UserFolders.AppSettingsFunctionsFolder -Force -Recurse
	}
	New-Item $PowerShellConsoleConstants.UserFolders.AppSettingsFunctionsFolder -Type Directory -Force | Out-Null
	Copy-Item -Path ".\Init Functions\*" -Destination $PowerShellConsoleConstants.UserFolders.AppSettingsFunctionsFolder -Force -Recurse

	New-Item $initFile -Type File -Force | Out-Null
	Set-Content -Path $initFile -Value `
@"
Get-ChildItem -Path "$($PowerShellConsoleConstants.UserFolders.AppSettingsFunctionsFolder)" -Filter "*.ps1" -File | % { . "`$(`$_.FullName)" }

Start-PowerShellConsole
"@
}

Invoke-InstallStep "Tokenizing Initialisation Functions" {
	$tokenTable = @{
		PowerShellConsoleEnabledFlagFile = $enabledFlagFile
		PowerShellConsoleDisabledFlagFile = $disabledFlagFile
		HStartPath = $PowerShellConsoleConstants.Executables.Hstart
		InternalInstallFile = (Join-Path $PowerShellConsoleConstants.InstallPath "Installation\Install\InternalInstall.bat")
		InternalUninstallFile = (Join-Path $PowerShellConsoleConstants.InstallPath "Installation\Uninstall\InternalUninstall.bat")
		ConEmuExecutablePath = $PowerShellConsoleConstants.Executables.ConEmu
		ConEmuCExecutablePath = $PowerShellConsoleConstants.Executables.ConEmuC
		InstallPath = $PowerShellConsoleConstants.InstallPath
		PowerShellConsoleModulePath = (Join-Path $PowerShellConsoleConstants.InstallPath "Custom Consoles\PowerShell\CustomPowerShellConsole.psd1")
	}
	Get-ChildItem -Path $PowerShellConsoleConstants.UserFolders.AppSettingsFunctionsFolder -Filter *.ps1 -File | % {
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