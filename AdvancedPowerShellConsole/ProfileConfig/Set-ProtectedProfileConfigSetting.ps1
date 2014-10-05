function Set-ProtectedProfileConfigSetting {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true)]$Name,
		[Parameter(Position=1)]$Value,
		[Parameter(Position=2)][System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	[hashtable]$rootProfileConfigSettings = Get-RootProtectedProfileConfigSettings -Scope $Scope
	$rootProfileConfigSettings[$Name] = $Value
	
	$protectectedConfigRoot = Protect-Object -Object $rootProfileConfigSettings -Scope $Scope

	if ($Scope -eq [System.Security.Cryptography.DataProtectionScope]::CurrentUser) {
		$ProfileConfig.ProtectedConfig.CurrentUser = $protectectedConfigRoot
	} elseif ($Scope -eq [System.Security.Cryptography.DataProtectionScope]::LocalMachine) {
		$ProfileConfig.ProtectedConfig.LocalMachine = $protectectedConfigRoot
	}
}