function Set-ProtectedProfileConfigSetting {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true)][string]$Name,
		[Parameter(Position=1,Mandatory=$true)]$Value,
		[switch]$Force,
		[System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	if (-not $Force -and $null -ne (Get-ProtectedProfileConfigSetting -Name $Name -Scope $Scope)) {
		throw "Setting already exists, use the -Force flag to overwrite it"
	}	

	$rootProfileConfigSettings = Get-RootProtectedProfileConfigSettings -Scope $Scope | Add-Member -MemberType NoteProperty -Name $Name -Value $Value -PassThru -Force:$Force

	$protectectedConfigRoot = Protect-Object -InputObject $rootProfileConfigSettings -Scope $Scope

	if ($Scope -eq [System.Security.Cryptography.DataProtectionScope]::CurrentUser) {
		$ProfileConfig.ProtectedConfig.CurrentUser = $protectectedConfigRoot
	} elseif ($Scope -eq [System.Security.Cryptography.DataProtectionScope]::LocalMachine) {
		$ProfileConfig.ProtectedConfig.LocalMachine = $protectectedConfigRoot
	}
}