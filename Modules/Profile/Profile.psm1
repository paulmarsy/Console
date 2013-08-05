param($InstallPath, $ProfileSettings)

"InstallPath: $InstallPath"
"ProfileSettings:"
"$ProfileSettings"

Get-ChildItem $PSScriptRoot -Include *.ps1 -Recurse | % { . $_.FullName -InstallPath $InstallPath $ProfileSettings }

# Include environment specific user file...
$includeFile = Join-Path ([System.Environment]::GetFolderPath("MyDocuments")) "include.ps1"
if (Test-Path $includeFile) {
	"Loading Environmental $includeFile..."
	. $includeFile $ProfileSettings
}

Export-ModuleMember -Function * -Alias * -Cmdlet * -Variable ProfileSettings
