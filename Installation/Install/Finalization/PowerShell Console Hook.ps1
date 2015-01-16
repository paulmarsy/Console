Write-InstallMessage -EnterNewScope "Configuring PowerShell Console Hook"

$PowerShellConsoleHookToken = "<# PowerShellConsole Hook #>"
$profileFolder = Split-Path $PowerShellConsoleConstants.HookFiles.PowerShell -Parent

Invoke-InstallStep "Setting up PowerShell Profile Directory" {
	if (!(Test-Path $profileFolder)) {
	    New-Item $profileFolder -Type Directory -Force | Out-Null
	}
	(Get-Item $profileFolder -Force).Attributes = 'Hidden'
}

Invoke-InstallStep "Adding hook to PowerShell Profile" {
	if (Test-Path $PowerShellConsoleConstants.HookFiles.PowerShell) {
		$token = Get-Content $PowerShellConsoleConstants.HookFiles.PowerShell | Select-Object -First 1
	 	if ($token -ne $PowerShellConsoleHookToken) {
	 		$profileBackupPath = Join-Path $PowerShellConsoleConstants.UserFolders.UserScriptsFolder ("$([IO.Path]::GetFileName($PowerShellConsoleConstants.HookFile)).bak")
	    	Write-InstallMessage -Type Warning "Existing $($PowerShellConsoleConstants.HookFiles.PowerShell) file exists, backing up to $profileBackupPath"
	    	Copy-Item $PowerShellConsoleConstants.HookFiles.PowerShell $profileBackupPath
		}
		Remove-Item $PowerShellConsoleConstants.HookFiles.PowerShell -Force
	}

	New-Item $PowerShellConsoleConstants.HookFiles.PowerShell -Type File -Force | Out-Null
	Set-Content -Path $PowerShellConsoleConstants.HookFiles.PowerShell -Encoding UTF8 -Value `
@"
$($PowerShellConsoleHookToken)

. "$(Join-Path $PowerShellConsoleConstants.UserFolders.AppSettingsFolder 'Init.ps1')"
"@
}

Exit-Scope