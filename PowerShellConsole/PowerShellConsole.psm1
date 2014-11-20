Set-StrictMode -Version Latest

$InstallPath = Get-Item -Path Env:\PowerShellConsoleInstallPath | % Value

$ModuleFastInit = & (Join-Path $PSScriptRoot "Helpers\Module Fast-Init Check.ps1")

if (-not $ModuleFastInit) { Import-Module (Join-Path $PSScriptRoot "Helpers\Profiler.psm1") }
Get-Item -Path (Join-Path $PSScriptRoot "ModuleInitialization") -PipelineVariable ModuleInitializationDir | Get-ChildItem | ? PSIsContainer | Sort-Object -Property Name | 
	% { Get-ChildItem -Path $_.FullName -Recurse -Filter "*.ps1" |
		Sort-Object -Property @{Expression = { $_.Directory.Name -eq "Required" }; Ascending = $false}, Name  | % {
			if ($ModuleFastInit -and $_.Directory.Name -ne "Required") { return }
			if (-not $ModuleFastInit) { Set-ProfilerStep Begin ($_.FullName.Substring($ModuleInitializationDir.FullName.Length + 1)) }
			. "$($_.FullName)"
			if (-not $ModuleFastInit) { Set-ProfilerStep End }
		}
	}

& (Join-Path $PSScriptRoot "Helpers\Module Destructor.ps1")

Export-ModuleMember -Function $ProfileConfig.Temp.ModuleExports.Functions -Alias $ProfileConfig.Temp.ModuleExports.Aliases

Write-Host
Write-Host -ForegroundColor Green "PowerShell Console Module successfully loaded"
Write-Host -ForegroundColor DarkGreen "`t Use 'Show-PowerShellConsoleHelp' for a list of available commands"