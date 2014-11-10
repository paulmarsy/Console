function Test-ProtectedProfileConfigSetting {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true)][string]$Name,
		[Parameter(Position=1)][System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	return ($null -ne (Get-ProtectedProfileConfigSetting -Name $Name -Scope $Scope))
}