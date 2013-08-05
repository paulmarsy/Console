param($InstallPath, $ProfileSettings)

Get-ChildItem $PSScriptRoot -Include *.ps1 -Recurse | Sort-Object DirectoryName, Name | % { . $_.FullName -InstallPath $InstallPath $ProfileSettings }

# Include environment specific user file...
$includeFile = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "include.ps1"
if (Test-Path $includeFile) {
	Write-Host "Loading Environmental $includeFile..."
	. $includeFile $ProfileSettings
}

Export-ModuleMember -Function * -Alias * -Cmdlet * -Variable ProfileSettings