function UnProtect-String {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,ValueFromPipeline=$true)][string]$EncryptedInputObject,
        [System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	$unEncryptedBytes = UnProtect-Bytes -EncryptedBytes ([Convert]::FromBase64String($EncryptedInputObject)) -Scope $Scope
	
	return ([System.Text.Encoding]::UTF8.GetString($unEncryptedBytes))
}