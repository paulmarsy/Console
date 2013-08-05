param($InstallPath)

Get-ChildItem $PSScriptRoot -Include *.ps1 -Recurse | Sort-Object DirectoryName, Name | % { . $_.FullName -InstallPath $InstallPath }

# Include environment specific user file...
$includeFile = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "include.ps1"
if (Test-Path $includeFile) {
	Write-Host "Loading Environmental $includeFile..."
	. $includeFile
}

Export-ModuleMember -Function * -Alias * -Cmdlet *