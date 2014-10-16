Write-InstallMessage -EnterNewScope "Configuring Advanced PowerShell Console Hook"

$advancedPowerShellConsoleHookToken = "<# AdvancedPowerShellConsole Hook #>"
$profileToHookInto = $PROFILE.CurrentUserAllHosts
$profileFolder = Split-Path $profileToHookInto -Parent

Invoke-InstallStep "Setting up PowerShell Profile Directory" {
	if (!(Test-Path $profileFolder)) {
	    New-Item $profileFolder -Type Directory -Force | Out-Null
	}
	(Get-Item $profileFolder -Force).Attributes = 'Hidden'
}

Invoke-InstallStep "Adding hook to PowerShell Profile" {
	if (Test-Path $profileToHookInto) {
		$token = Get-Content $profileToHookInto | Select-Object -First 1
	 	if ($token -ne $advancedPowerShellConsoleHookToken) {
	 		$profileBackupPath = Join-Path $AdvancedPowerShellConsoleUserScriptsFolder ("$([IO.Path]::GetFileName($profileToHookInto)).bak")
	    	Write-InstallMessage -Type Warning "Existing $profileToHookInto file exists, backing up to $profileBackupPath"
	    	Copy-Item $profileToHookInto $profileBackupPath
		}
		Remove-Item $profileToHookInto -Force
	}

	New-Item $profileToHookInto -Type File -Force | Out-Null
	Set-Content -Path $profileToHookInto -Value `
@"
$($advancedPowerShellConsoleHookToken)

. "$(Join-Path $AdvancedPowerShellConsoleAppSettingsFolder 'Init.ps1')"
"@
}

Exit-Scope