Invoke-InstallStep "Creating App Settings Folders" {
	if (-not (Test-Path $AdvancedPowerShellConsoleAppSettingsFolder)) {
		New-Item $AdvancedPowerShellConsoleAppSettingsFolder -Type Directory -Force | Out-Null
	}
	(Get-Item $AdvancedPowerShellConsoleAppSettingsFolder -Force).Attributes = 'Hidden'
}

$functionsFolder = Join-Path $AdvancedPowerShellConsoleAppSettingsFolder "Functions"
$initFile = Join-Path $AdvancedPowerShellConsoleAppSettingsFolder "Init.ps1"
$enabledFlagFile = Join-Path $AdvancedPowerShellConsoleAppSettingsFolder "AdvancedPowerShellConsole.Enabled"
$disabledFlagFile = Join-Path $AdvancedPowerShellConsoleAppSettingsFolder "AdvancedPowerShellConsole.Disabled"

Invoke-InstallStep "Creating Initialisation Functions" {
	if (Test-Path $functionsFolder) {
		Remove-Item $functionsFolder -Force -Recurse
	}
	New-Item $functionsFolder -Type Directory -Force | Out-Null
	Copy-Item -Path ".\Init Functions\*" -Destination $functionsFolder -Force -Recurse

	New-Item $initFile -Type File -Force | Out-Null
	Set-Content -Path $initFile -Value `
@"
Get-ChildItem -Path "$functionsFolder" -Filter *.ps1 | % { . `$_.FullName }

Test-AdvancedPowerShellConsoleFlagFile
Start-AdvancedPowerShellConsole
"@
}

Invoke-InstallStep "Tokenizing Initialisation Functions" {
	$tokenTable = @{
		AdvancedPowerShellConsoleEnabledFlagFile = $enabledFlagFile
		AdvancedPowerShellConsoleDisabledFlagFile = $disabledFlagFile
		HStartPath = (Join-Path $InstallPath "Third Party\Binaries\hstart64.exe")
		InternalInstallFile = (Join-Path $InstallPath "Install\Scripts\InternalInstall.bat")
		ConEmuExecutablePath = $ConEmuExecutablePath
		InstallPath = $InstallPath
		AdvancedPowerShellConsoleModulePath = (Join-Path $InstallPath "AdvancedPowerShellConsole")
	}
	Get-ChildItem -Path $functionsFolder -Filter *.ps1 | % {
		$functionText = [System.IO.File]::ReadAllText($_.FullName)
		$tokenTable.GetEnumerator() | % {
			$token = "##$($_.Name)##"
			$value = $_.Value
			$functionText = $functionText.Replace($token, $value)
		}
		[System.IO.File]::WriteAllText($_.FullName, $functionText)
	}
}

Invoke-InstallStep "Setting Advanced PowerShell Console enabled flag on" {
	Set-Content -Path $enabledFlagFile -Value $null
	if (Test-Path $disabledFlagFile) {
		Remove-Item $disabledFlagFile -Force
	}
}