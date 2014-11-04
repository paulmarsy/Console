Write-InstallMessage -EnterNewScope "Configuring PowerShell Console Hook"

$PowerShellConsoleHookToken = "<# PowerShellConsole Hook #>"
$profileFolder = Split-Path $PowerShellConsoleContstants.HookFile -Parent

Invoke-InstallStep "Setting up PowerShell Profile Directory" {
	if (!(Test-Path $profileFolder)) {
	    New-Item $profileFolder -Type Directory -Force | Out-Null
	}
	(Get-Item $profileFolder -Force).Attributes = 'Hidden'
}

Invoke-InstallStep "Adding hook to PowerShell Profile" {
	if (Test-Path $PowerShellConsoleContstants.HookFile) {
		$token = Get-Content $PowerShellConsoleContstants.HookFile | Select-Object -First 1
	 	if ($token -ne $PowerShellConsoleHookToken) {
	 		$profileBackupPath = Join-Path $PowerShellConsoleContstants.UserFolders.UserScriptsFolder ("$([IO.Path]::GetFileName($PowerShellConsoleContstants.HookFile)).bak")
	    	Write-InstallMessage -Type Warning "Existing $($PowerShellConsoleContstants.HookFile) file exists, backing up to $profileBackupPath"
	    	Copy-Item $PowerShellConsoleContstants.HookFile $profileBackupPath
		}
		Remove-Item $PowerShellConsoleContstants.HookFile -Force
	}

	New-Item $PowerShellConsoleContstants.HookFile -Type File -Force | Out-Null
	Set-Content -Path $PowerShellConsoleContstants.HookFile -Encoding UTF8 -Value `
@"
$($PowerShellConsoleHookToken)

. "$(Join-Path $PowerShellConsoleContstants.UserFolders.AppSettingsFolder 'Init.ps1')"
"@
}

Exit-Scope