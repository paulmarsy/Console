function Protect-File {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][ValidateScript({Test-Path $_})]$Path,
        [System.Security.Cryptography.DataProtectionScope]$Scope = [System.Security.Cryptography.DataProtectionScope]::CurrentUser,
        [Parameter(ParameterSetName = "Backup")][switch]$SaveUnProtectedFile,
        [Parameter(ParameterSetName = "Backup")]$BackupExtension = "unprotected",
        [Parameter(ParameterSetName = "Backup")][switch]$Force
	)

	$Path = Resolve-Path $Path | select -ExpandProperty Path

	if ($SaveUnProtectedFile) {
		$backupFile = [IO.Path]::ChangeExtension($Path, $BackupExtension)
		if (-not $force -and (Test-Path $backupFile)) {
			throw "Backup file ($backupFile) already exists, specify -Force parameter to overwrite"
		}

		Copy-Item -Path $Path -Destination $backupFile -Force
	}

	$unEncryptedBytes = [System.IO.File]::ReadAllBytes($Path)
	
	$encryptedBytes = [System.Security.Cryptography.ProtectedData]::Protect($unEncryptedBytes, $null, $Scope)

	[System.IO.File]::WriteAllBytes($Path, $encryptedBytes)
}