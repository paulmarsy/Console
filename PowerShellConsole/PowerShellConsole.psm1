Set-StrictMode -Version Latest

$ConsoleRoot = Resolve-Path -Path (Join-Path $PSScriptRoot "..\") | % Path

$profiler = @{
	RawData = ({@()}.Invoke())
}
$moduleInitialization = Join-Path $PSScriptRoot "ModuleInitialization"
Get-ChildItem -Path $moduleInitialization -Filter *.ps1 -Recurse | Sort-Object FullName | % {
	$profiledItem = @{
		FullName = $_.FullName
		Start = ([System.DateTime]::Now.Ticks)
	}
	. "$($_.FullName)"
	$profiledItem.Finish = [System.DateTime]::Now.Ticks
	$profiler.RawData.Add((New-Object -TypeName PSObject -Property $profiledItem))
}

$profiler.Report = @{
	Actions = ({@()}.Invoke())
	TotalTime = ([System.TimeSpan]::FromTicks((($profiler.RawData | Select-Object -Last 1 | % Finish) - ($profiler.RawData | Select-Object -First 1 | % Start))))
}
$profiler.RawData | % {
	$duration = [System.TimeSpan]::FromTicks($_.Finish - $_.Start)
	$profiler.Report.Actions.Add((New-Object -TypeName PSObject -Property @{
		Name = ($_.FullName.Substring($moduleInitialization.Length + 1))
		Duration = $duration
		Milliseconds = ($duration.TotalMilliseconds.ToString())
	}))
}
$profiler.Report.HighestImpact = $profiler.Report.Actions | Sort-Object -Property Duration -Descending | Select-Object -First 1 | % { "$($_.Name) ($($_.Milliseconds) milliseconds)" }

$ProfileConfig.Temp.ModuleInitializationProfiler = $profiler

& (Join-Path $PSScriptRoot "Module Destructor.ps1")

Export-ModuleMember -Function $ProfileConfig.Temp.ModuleExports.Functions -Alias $ProfileConfig.Temp.ModuleExports.Aliases

Write-Host
Write-Host -ForegroundColor Green "PowerShell Console Module successfully loaded"
Write-Host -ForegroundColor DarkGreen "`t Use 'Show-PowerShellConsoleHelp' for a list of available commands"