function Add-FolderToPath {
	param(
		[Parameter(Mandatory=$true)]$FolderToAdd
	)

	$resolvedFolderToAdd = Resolve-Path $FolderToAdd

	if (-not (Test-Path $resolvedFolderToAdd)) {
		throw "$resolvedFolderToAdd does not exist"
	}

	$updatedPath = "{0};{1}" -f $Env:PATH, $resolvedFolderToAdd
	[System.Environment]::SetEnvironmentVariable("PATH", $updatedPath, [System.EnvironmentVariableTarget]::Process)
}