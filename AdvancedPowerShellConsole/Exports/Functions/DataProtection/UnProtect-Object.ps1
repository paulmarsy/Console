function UnProtect-Object {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$EncryptedInputObject,
        [System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	$jsonRepresentation = UnProtect-String -EncryptedInputObject $EncryptedInputObject -Scope $Scope

	return (ConvertFrom-Json -InputObject $jsonRepresentation)
}