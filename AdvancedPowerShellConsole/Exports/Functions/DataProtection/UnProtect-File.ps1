function UnProtect-File {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][ValidateScript({Test-Path $_})]$Path,
        [System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser,
        [Parameter(ParameterSetName = "Backup")][switch]$SaveProtectedFile,
        [Parameter(ParameterSetName = "Backup")]$backupExtension = "protected",
        [Parameter(ParameterSetName = "Backup")][switch]$Force
	)

	$Path = Resolve-Path $Path | select -ExpandProperty Path

	if ($SaveProtectedFile) {
		$backupFile = [IO.Path]::ChangeExtension($Path, $backupExtension)
		if (-not $force -and (Test-Path $backupFile)) {
			throw "Backup file ($backupFile) already exists, specify -Force parameter to overwrite"
		}

		Copy-Item -Path $Path -Destination $backupFile -Force
	}

 	$encryptedBytes = [System.IO.File]::ReadAllBytes($Path)

	$unEncryptedBytes = [System.Security.Cryptography.ProtectedData]::UnProtect($encryptedBytes, $null, $Scope)
	
	[System.IO.File]::WriteAllBytes($Path, $unEncryptedBytes)
}