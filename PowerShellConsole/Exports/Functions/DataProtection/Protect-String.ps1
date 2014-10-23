function Protect-String {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$InputObject,
        [System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	$unEncryptedBytes = [System.Text.Encoding]::UTF8.GetBytes($InputObject)
	
	$encryptedBytes = [System.Security.Cryptography.ProtectedData]::Protect($unEncryptedBytes, $null, $Scope)

	return ([Convert]::ToBase64String($encryptedBytes))
}