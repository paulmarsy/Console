Invoke-InstallStep "Creating App Settings Folders" {
	if (-not (Test-Path $PowerShellConsoleAppSettingsFolder)) {
		New-Item $PowerShellConsoleAppSettingsFolder -Type Directory -Force | Out-Null
	}
	(Get-Item $PowerShellConsoleAppSettingsFolder -Force).Attributes = 'Hidden'
}

$functionsFolder = Join-Path $PowerShellConsoleAppSettingsFolder "Functions"
$initFile = Join-Path $PowerShellConsoleAppSettingsFolder "Init.ps1"
$enabledFlagFile = Join-Path $PowerShellConsoleAppSettingsFolder "PowerShellConsole.Enabled.status"
$disabledFlagFile = Join-Path $PowerShellConsoleAppSettingsFolder "PowerShellConsole.Disabled.status"

Invoke-InstallStep "Creating Initialisation Functions" {
	if (Test-Path $functionsFolder) {
		Remove-Item $functionsFolder -Force -Recurse
	}
	New-Item $functionsFolder -Type Directory -Force | Out-Null
	Copy-Item -Path ".\Init Functions\*" -Destination $functionsFolder -Force -Recurse

	New-Item $initFile -Type File -Force | Out-Null
	Set-Content -Path $initFile -Value `
@"
Get-ChildItem -Path "$functionsFolder" -Filter "*.ps1" | % { . "`$(`$_.FullName)" }

Start-PowerShellConsole
"@
}

Invoke-InstallStep "Tokenizing Initialisation Functions" {
	$tokenTable = @{
		PowerShellConsoleEnabledFlagFile = $enabledFlagFile
		PowerShellConsoleDisabledFlagFile = $disabledFlagFile
		HStartPath = (Join-Path $InstallPath "Third Party\Binaries\hstart64.exe")
		InternalInstallFile = (Join-Path $InstallPath "Install\Scripts\InternalInstall.bat")
		ConEmuExecutablePath = $ConEmuExecutablePath
		InstallPath = $InstallPath
		PowerShellConsoleModulePath = (Join-Path $InstallPath "PowerShellConsole")
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

Invoke-InstallStep "Setting PowerShell Console enabled flag" {
	Set-Content -Path $enabledFlagFile -Value $null
	if (Test-Path $disabledFlagFile) {
		Remove-Item $disabledFlagFile -Force
	}
}