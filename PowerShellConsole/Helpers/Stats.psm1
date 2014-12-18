param($AppSettingsFolder)

Set-StrictMode -Version Latest

$ModuleStatsFilePath = Join-Path $AppSettingsFolder "ModuleStats.json"

function Get-DefaultStats {
	$defaultStats = @{}
	$module = Get-Module PowerShellConsole
	if ($null -ne $module) {
		$module.ExportedFunctions.Keys | % { $defaultStats.Add($_, 0) }
		$module.ExportedAliases.Keys | % { $defaultStats.Add($_, 0) }
	}
	return $defaultStats
}

function Load-ModuleStats {
	param($currentStats)

	if (-not (Test-Path $ModuleStatsFilePath)) { return $currentStats }
	
	$existingStats =  Get-Content -Path $ModuleStatsFilePath -Raw | ConvertFrom-Json

	$updatedStats = @{}
	$currentStats.GetEnumerator() | % {
		$newCount = $_.Value

		$newCount += Select-Object -InputObject $existingStats -Property $_.Key | Select-Object -ExpandProperty $_.Key

		$updatedStats.Add($_.Key, $newCount)
	}

	return $updatedStats
}

function Save-ModuleStats {
	param($currentStats)

	ConvertTo-Json -InputObject $currentStats | Set-Content -Path $ModuleStatsFilePath
}

function Update-ModuleUsageStats {
	$defaultStats =  Get-DefaultStats

	$currentStats = Load-ModuleStats $defaultStats
	Microsoft.PowerShell.Core\Get-History |
		% { [System.Management.Automation.PSParser]::Tokenize($_.CommandLine, [ref]$null) } | 
		? Type -eq ([System.Management.Automation.PSTokenType]::Command) | 
		% Content |
		% {	if ($currentStats.ContainsKey($_)) { $currentStats[$_]++ } }


	Save-ModuleStats $currentStats

	Microsoft.PowerShell.Core\Clear-History
}

function Show-ModuleUsageStats {
	$defaultStats =  Get-DefaultStats

	$currentStats = Load-ModuleStats $defaultStats

	$currentStats.GetEnumerator() | Sort-Object -Property Value -Descending | Format-Table -AutoSize -Property @(@{Label = "Name"; Expression = { $_.Key }}, @{Label = "Usage Count"; Expression = { $_.Value }})
}

function Initialize-Destructor {
	$destructor = {
		Update-ModuleUsageStats
	}

	$psEngineExitEventJob = Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action $destructor

	$ExecutionContext.SessionState.Module.OnRemove = {
	    $psEngineExitEventJob | Stop-Job -PassThru | Remove-Job

	    $destructor.Invoke()
	}.GetNewClosure()
}

Initialize-Destructor

Export-ModuleMember -Function @("Show-ModuleUsageStats", "Update-ModuleUsageStats")