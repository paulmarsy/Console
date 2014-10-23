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

	if ($null -eq $protectectedConfigRoot) {
		return (New-Object -TypeName System.Management.Automation.PSObject)
	} else {
		return (UnProtect-Object -EncryptedInputObject $protectectedConfigRoot -Scope $Scope)
	}
}