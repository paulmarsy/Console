param($InstallPath)

Set-StrictMode -Version Latest

Import-Module (Join-Path $PSScriptRoot "ProfileConfig") -ArgumentList $InstallPath -Global

Get-ChildItem (Join-Path $PSScriptRoot "ModuleInitialization") -Filter *.ps1 -Recurse | Sort-Object FullName | % { & $_.FullName }

$functions = Get-ChildItem (Join-Path $PSScriptRoot "Exports\Functions") -Filter *.ps1 -Recurse
$aliases = Get-ChildItem (Join-Path $PSScriptRoot "Exports\Aliases") -Filter *.ps1 -Recurse

$functions + $aliases | % { . $_.FullName }

if (Test-NetworkStatus) {
	if (Assert-ConsoleIsInSync -Quiet) {
		Sync-ConsoleWithGitHub -DontPushToGitHub -UpdateConsole Auto
	} else {
		_updateGitHubCmdletParameters
	}
} else {
	Write-Host -ForegroundColor Red "Unable to synchronise with GitHub due to a lack of network connectivity"
}

$exportExclusionPattern = "_*.ps1"

Export-ModuleMember -Function ($functions | ? { $_ -notlike $exportExclusionPattern } | % { $_.BaseName })
Export-ModuleMember -Alias  ($aliases | ? { $_ -notlike $exportExclusionPattern } | % { $_.BaseName })

Write-Host
Import-UserScripts -ExportExclusionPattern $exportExclusionPattern -ModuleInit
Write-Host

Write-Host -ForegroundColor Green "Advanced PowerShell Console Module successfully loaded"