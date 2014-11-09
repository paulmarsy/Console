Write-InstallMessage -EnterNewScope "Configuring PowerShell Console Hook"

$PowerShellConsoleHookToken = "<# PowerShellConsole Hook #>"
$profileFolder = Split-Path $PowerShellConsoleContstants.HookFiles.PowerShell -Parent

Invoke-InstallStep "Setting up PowerShell Profile Directory" {
	if (!(Test-Path $profileFolder)) {
	    New-Item $profileFolder -Type Directory -Force | Out-Null
	}
	(Get-Item $profileFolder -Force).Attributes = 'Hidden'
}

Invoke-InstallStep "Adding hook to PowerShell Profile" {
	if (Test-Path $PowerShellConsoleContstants.HookFiles.PowerShell) {
		$token = Get-Content $PowerShellConsoleContstants.HookFiles.PowerShell | Select-Object -First 1
	 	if ($token -ne $PowerShellConsoleHookToken) {
	 		$profileBackupPath = Join-Path $PowerShellConsoleContstants.UserFolders.UserScriptsFolder ("$([IO.Path]::GetFileName($PowerShellConsoleContstants.HookFile)).bak")
	    	Write-InstallMessage -Type Warning "Existing $($PowerShellConsoleContstants.HookFiles.PowerShell) file exists, backing up to $profileBackupPath"
	    	Copy-Item $PowerShellConsoleContstants.HookFiles.PowerShell $profileBackupPath
		}
		Remove-Item $PowerShellConsoleContstants.HookFiles.PowerShell -Force
	}

	New-Item $PowerShellConsoleContstants.HookFiles.PowerShell -Type File -Force | Out-Null
	Set-Content -Path $PowerShellConsoleContstants.HookFiles.PowerShell -Encoding UTF8 -Value `
@"
$($PowerShellConsoleHookToken)

. "$(Join-Path $PowerShellConsoleContstants.UserFolders.AppSettingsFolder 'Init.ps1')"
"@
}

Exit-Scope