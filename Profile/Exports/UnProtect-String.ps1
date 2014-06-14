function UnProtect-String {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$encryptedString,
        [System.Security.Cryptography.DataProtectionScope]$scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

 	$encryptedBytes = [Convert]::FromBase64String($encryptedString)

	$unEncryptedBytes = [System.Security.Cryptography.ProtectedData]::UnProtect($encryptedBytes, $null, $scope)
	
	return ([System.Text.Encoding]::UTF8.GetString($unEncryptedBytes))
}
@{Function = "UnProtect-String"}