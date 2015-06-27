function Protect-String {
	[OutputType([System.String])]
	param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$InputObject,
        [System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	$encryptedBytes = Protect-Bytes -UnEncryptedBytes ([System.Text.Encoding]::UTF8.GetBytes($InputObject)) -Scope $Scope

	return ([Convert]::ToBase64String($encryptedBytes))
}