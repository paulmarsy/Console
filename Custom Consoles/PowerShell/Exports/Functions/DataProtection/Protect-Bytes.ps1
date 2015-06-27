function Protect-Bytes {
	[OutputType([array])]
	param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]$UnEncryptedBytes,
        [System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	try {
		return @([System.Security.Cryptography.ProtectedData]::Protect($UnEncryptedBytes, $null, $Scope))
	}
	catch {
		Write-Warning "Unable to encrypt byte array - value returned will be empty"
		return @([byte]0x20) # Space in ASCII
	}
}