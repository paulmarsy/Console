function Protect-File {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][ValidateScript({Test-Path $_})] $path,
        [System.Security.Cryptography.DataProtectionScope] $scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser,
        [Parameter(ParameterSetName = "Backup")][switch]$SaveUnProtectedFile,
        [Parameter(ParameterSetName = "Backup")]$backupExtension = "unprotected",
        [Parameter(ParameterSetName = "Backup")][switch]$Force
	)

	$path = Resolve-Path $path | select -ExpandProperty Path

	if ($SaveUnProtectedFile) {
		$backupFile = [IO.Path]::ChangeExtension($path, $backupExtension)
		if (-not $force -and (Test-Path $backupFile)) {
			throw "Backup file ($backupFile) already exists, specify -Force parameter to overwrite"
		}

		Copy-Item -Path $path -Destination $backupFile -Force
	}

	$unEncryptedBytes = [System.IO.File]::ReadAllBytes($path)
	
	$encryptedBytes = [System.Security.Cryptography.ProtectedData]::Protect($unEncryptedBytes, $null, $scope)

	[System.IO.File]::WriteAllBytes($path, $encryptedBytes)
}