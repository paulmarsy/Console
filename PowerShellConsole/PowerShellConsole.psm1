Set-StrictMode -Version Latest

$ConsoleRoot = Resolve-Path -Path (Join-Path $PSScriptRoot "..\") | % Path

$ModuleFastInit = & (Join-Path $PSScriptRoot "Helpers\Module Fast-Init Check.ps1")

#if (-not $ModuleFastInit) { $profileHistoryStart = Get-History | Select-Object -Last 1 -ExpandProperty Id }
Get-ChildItem -Path (Join-Path $PSScriptRoot "ModuleInitialization") | ? PSIsContainer | Sort-Object -Property Name | 
	% { Get-ChildItem -Path $_.FullName -Recurse -Filter "*.ps1" |
		Sort-Object -Property @{Expression = { $_.Directory.Name -eq "Required" }; Ascending = $false}, Name  | % {
			if ($ModuleFastInit -and $_.Directory.Name -ne "Required") { return }
			. "$($_.FullName)"
		}
	}
#if (-not $ModuleFastInit) {
	#$profileHistoryEnd = Get-History | Select-Object -Last 1 -ExpandProperty Id
	#& (Join-Path $PSScriptRoot "Helpers\Module Profiler.ps1") -HistoryStartId $profileHistoryStart -HistoryEndId $profileHistoryEnd
#}

& (Join-Path $PSScriptRoot "Helpers\Module Destructor.ps1")

Export-ModuleMember -Function $ProfileConfig.Temp.ModuleExports.Functions -Alias $ProfileConfig.Temp.ModuleExports.Aliases

Write-Host
Write-Host -ForegroundColor Green "PowerShell Console Module successfully loaded"
Write-Host -ForegroundColor DarkGreen "`t Use 'Show-PowerShellConsoleHelp' for a list of available commands"