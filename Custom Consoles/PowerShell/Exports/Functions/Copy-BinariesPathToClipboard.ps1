function Copy-BinariesPathToClipboard {
	Set-Clipboard -Text (Join-Path $ProfileConfig.Module.InstallPath "Libraries\PATH Extensions")
	Write-Host -ForegroundColor Green "Copied to clipboard."
}