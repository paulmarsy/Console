function Get-RootProtectedProfileConfigSettings {
	[CmdletBinding()]
	param(
		[Parameter(Position=0)][System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	if ($Scope -eq [System.Security.Cryptography.DataProtectionScope]::CurrentUser) {
		$protectectedConfigRoot = $ProfileConfig.ProtectedConfig.CurrentUser
	} elseif ($Scope -eq [System.Security.Cryptography.DataProtectionScope]::LocalMachine) {
		$protectectedConfigRoot = $ProfileConfig.ProtectedConfig.LocalMachine
	}

	$configRoot = $null
	if (Is -Not -InputObject $protectectedConfigRoot NullOrWhiteSpace -Bool) {
		$configRoot = UnProtect-Object -EncryptedInputObject $protectectedConfigRoot -Scope $Scope
		if (Is -InputObject $configRoot NullOrWhiteSpace -Bool) {
			Write-Warning "Unable to decrypt root protect object - has the user or machine changed? Backing up current ProtectConfig to `$ProfileConfig.BackedUpProtectedConfig and initializing a new root"
			$ProfileConfig.BackedUpProtectedConfig = $ProfileConfig.ProtectedConfig
			if ($Scope -eq [System.Security.Cryptography.DataProtectionScope]::CurrentUser) {
				$ProfileConfig.ProtectedConfig.CurrentUser = $null
			} elseif ($Scope -eq [System.Security.Cryptography.DataProtectionScope]::LocalMachine) {
				$ProfileConfig.ProtectedConfig.LocalMachine = $null
			}
		}
	}

	if ($null -eq $configRoot) {
		return (New-Object -TypeName System.Management.Automation.PSObject)
	} else {
		return $configRoot
	}
}