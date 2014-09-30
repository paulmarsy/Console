function Get-ProtectedProfileConfigSetting {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true)]$Name,
		[Parameter(Position=0)][System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	[hashtable]$rootProfileConfigSettings = Get-RootProtectedProfileConfigSettings -Scope $Scope

	if ($rootProfileConfigSettings.ContainsKey($Name)) {
		return $rootProfileConfigSettings[$Name]
	} else {
		return $null
	}
}