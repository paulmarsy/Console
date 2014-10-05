function UnProtect-String {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$EncryptedInputObject,
        [System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

 	$encryptedBytes = [Convert]::FromBase64String($EncryptedInputObject)

	$unEncryptedBytes = [System.Security.Cryptography.ProtectedData]::UnProtect($encryptedBytes, $null, $Scope)
	
	return ([System.Text.Encoding]::UTF8.GetString($unEncryptedBytes))
}