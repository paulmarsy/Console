function UnProtect-Bytes {
	[OutputType([array])]
	param(
		[Parameter(Position=0,ValueFromPipeline=$true)]$EncryptedBytes,
        [System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	try {
		return ([System.Security.Cryptography.ProtectedData]::UnProtect($EncryptedBytes, $null, $Scope))
	}
	catch {
		Write-Warning "Unable to decrypt byte array - value returned will be empty"
		return @(0x20) # Space in ASCII
	}
}