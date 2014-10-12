Invoke-InstallStep "Creating PowerShell Scratchpad Folder" {
	$scratchpadFolder = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "PowerShell Scratchpad"
	if (-not (Test-Path $scratchpadFolder)) {
		New-Item $scratchpadFolder -Type Directory -Force | Out-Null
	}
}