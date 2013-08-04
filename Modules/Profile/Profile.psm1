param($InstallPath)

"InstallPath: $InstallPath"

Get-ChildItem $PSScriptRoot -Include *.ps1 -Recurse | % { . $_.FullName -InstallPath $InstallPath }

# Include environment specific user file...
$includeFile = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "include.ps1"
if (Test-Path $includeFile) {
	"Loading $includeFile..."
	. $includeFile
}

Export-ModuleMember -Function * -Alias * -Cmdlet *