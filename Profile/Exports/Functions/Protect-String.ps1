function Protect-String {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$string,
        [System.Security.Cryptography.DataProtectionScope]$scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser
	)

	$unEncryptedBytes = [System.Text.Encoding]::UTF8.GetBytes($string)
	
	$encryptedBytes = [System.Security.Cryptography.ProtectedData]::Protect($unEncryptedBytes, $null, $scope)

	return ([Convert]::ToBase64String($encryptedBytes))
}