Set-StrictMode -Version Latest

"Checking for prerequisites..."
$prerequisitesMet = & ".\Prerequisites Check.ps1"
if (-not $prerequisitesMet) {
	return
}

"Configuring Console..."
$InstallPath = Resolve-Path (Join-Path $pwd.Path '..\..\')
Get-ChildItem .\Configure | % {
    & $_.FullName
}