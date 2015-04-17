param($AppSettingsFolder)

Set-StrictMode -Version Latest

$ExecutionContext.SessionState.Module.PrivateData = @{
	ModuleStatsFilePath = (Join-Path $AppSettingsFolder "ModuleStats.json")
	LastSavedHistoryId = -1
}

function Get-DefaultStats {
	param($module)

	$defaultStats = @{}

	if ($null -ne $module) {
		$module.ExportedFunctions.Keys | % { $defaultStats.Add($_, 0) }
		$module.ExportedAliases.Keys | % { $defaultStats.Add($_, 0) }
	}
	
	return $defaultStats
}

function Load-ModuleStats {
	param($currentStats)

	if (-not (Test-Path $ExecutionContext.SessionState.Module.PrivateData.ModuleStatsFilePath)) { return $currentStats }
	
	$existingStats =  Get-Content -Path $ExecutionContext.SessionState.Module.PrivateData.ModuleStatsFilePath -Raw | ConvertFrom-Json

	$updatedStats = @{}
	$currentStats.GetEnumerator() | % {
		$newCount = $_.Value

		$newCount += Select-Object -InputObject $existingStats -Property $_.Key | Select-Object -ExpandProperty $_.Key

		$updatedStats.Add($_.Key, $newCount)
	}

	return $updatedStats
}

function Save-ModuleStats {
	param($currentStats, $LastSavedHistoryId)

	ConvertTo-Json -InputObject $currentStats | Set-Content -Path $ExecutionContext.SessionState.Module.PrivateData.ModuleStatsFilePath
	$ExecutionContext.SessionState.Module.PrivateData.Item("LastSavedHistoryId") = $LastSavedHistoryId
}

function Update-ModuleUsageStats {
	$module = Get-Module CustomPowerShellConsole
	$moduleAliases = $module | % ExportedAliases | % Values
	$defaultStats =  Get-DefaultStats $module
	
	$currentStats = Load-ModuleStats $defaultStats

	$lastSavedHistoryId = [int]$ExecutionContext.SessionState.Module.PrivateData.Item("LastSavedHistoryId")

	foreach ($historyItem in (Microsoft.PowerShell.Core\Get-History)) {
		if ($lastSavedHistoryId -ne -1 -and $historyItem.Id -le $lastSavedHistoryId) { continue }
		foreach ($parsedHistoryCommand in [System.Management.Automation.PSParser]::Tokenize($historyItem.CommandLine, [ref]$null)) {
			if ($parsedHistoryCommand.Type -ne ([System.Management.Automation.PSTokenType]::Command)) { continue }

			$historyCommandName = $parsedHistoryCommand.Content
			$lastSavedHistoryId = $historyItem.Id
			if (-not $currentStats.ContainsKey($historyCommandName)) { continue }

			# Update the function
			 $currentStats[$historyCommandName]++

			# Update the underlying function as well if this is an alias
			$aliasedCommand = $moduleAliases | ? Name -eq $historyCommandName | % Definition
			if ($null -ne $aliasedCommand) { $currentStats[$aliasedCommand]++ }
		}
	}

	Save-ModuleStats $currentStats $lastSavedHistoryId
}

function Show-ModuleUsageStats {
	$module = Get-Module CustomPowerShellConsole
	$defaultStats =  Get-DefaultStats $module

	$currentStats = Load-ModuleStats $defaultStats

	$currentStats.GetEnumerator() | Sort-Object -Property @(@{Expression={$_.Value}; Ascending=$false}, @{Expression={$_.Key}; Ascending=$true}) | Format-Table -AutoSize -Property @(@{Label = "Name"; Expression = { $_.Key }}, @{Label = "Usage Count"; Expression = { $_.Value }})
}

function Initialize-BackgroundSaveTask {
	$backgroundSaveTask = { Update-ModuleUsageStats }
	$Global:OnIdleScriptBlockCollection += $backgroundSaveTask
	$ExecutionContext.SessionState.Module.OnRemove = $backgroundSaveTask
}

Initialize-BackgroundSaveTask

Export-ModuleMember -Function @("Show-ModuleUsageStats")