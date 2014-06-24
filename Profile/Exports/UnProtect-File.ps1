function UnProtect-File {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][ValidateScript({Test-Path $_})] $path,
        [System.Security.Cryptography.DataProtectionScope] $scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser,
        [Parameter(ParameterSetName = "Backup")][switch]$SaveProtectedFile,
        [Parameter(ParameterSetName = "Backup")]$backupExtension = "protected",
        [Parameter(ParameterSetName = "Backup")][switch]$Force
	)

	$path = Resolve-Path $path | select -ExpandProperty Path

	if ($SaveProtectedFile) {
		$backupFile = [IO.Path]::ChangeExtension($path, $backupExtension)
		if (-not $force -and (Test-Path $backupFile)) {
			Write-Error "Backup file ($backupFile) already exists, specify -Force parameter to overwrite"
		}

		Copy-Item -Path $path -Destination $backupFile -Force
	}

 	$encryptedBytes = [System.IO.File]::ReadAllBytes($path)

	$unEncryptedBytes = [System.Security.Cryptography.ProtectedData]::UnProtect($encryptedBytes, $null, $scope)
	
	[System.IO.File]::WriteAllBytes($path, $unEncryptedBytes)
}
@{Function = "UnProtect-File"}