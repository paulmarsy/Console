Invoke-InstallStep "Creating User Scripts Folder" {
	if (-not (Test-Path $AdvancedPowerShellConsoleUserScriptsFolder)) {
		New-Item $AdvancedPowerShellConsoleUserScriptsFolder -Type Directory -Force | Out-Null
	}
}

$includeFile = Join-Path $AdvancedPowerShellConsoleUserScriptsFolder "include.ps1"
if (-not (Test-Path $includeFile)) {
	Invoke-InstallStep "Creating empty include.ps1 file in PowerShell Scripts Folder" {
		Set-Content -LiteralPath $includeFile -Value $null
	}
}