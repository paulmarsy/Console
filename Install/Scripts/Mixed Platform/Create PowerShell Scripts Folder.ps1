Invoke-InstallStep "Creating PowerShell Scripts Folder" {
	$userScriptsFolder = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "PowerShell Scripts"
	if (-not (Test-Path $userScriptsFolder)) {
		New-Item $userScriptsFolder -Type Directory -Force | Out-Null
	}

	$includeFile = Join-Path $userScriptsFolder "include.ps1"
	if (-not (Test-Path $includeFile)) {
		Write-InstallMessage "Creating empty include.ps1 file in PowerShell Scripts Folder"
		Set-Content -LiteralPath $includeFile -Value $null
	}
}