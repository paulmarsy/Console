param(
	$HistoryStartId,
	$HistoryEndId
)

$profiler = @{
	RawData = ({@()}.Invoke())
}

for($i = $HistoryStartId; $i -le $HistoryEndId; $i++) {
	$historyItem = Get-History -Id $i
	if ($historyItem.CommandLine.StartsWith(".")) {
		$profiler.RawData.Add((New-Object -TypeName PSObject -Property @{
			Name = $historyItem.CommandLine.Remove(0, 4)
			Status = $historyItem.ExecutionStatus
			Start = $historyItem.StartExecutionTime.Ticks
			Finish = $historyItem.EndExecutionTime.Ticks
		}))
	}
}

$profiler.Report = @{
	Actions = ({@()}.Invoke())
	TotalTime = ([System.TimeSpan]::FromTicks((($profiler.RawData | Select-Object -Last 1 | % Finish) - ($profiler.RawData | Select-Object -First 1 | % Start))))
}
$profiler.RawData | % {
	$duration = [System.TimeSpan]::FromTicks($_.Finish - $_.Start)
	$profiler.Report.Actions.Add((New-Object -TypeName PSObject -Property @{
		Name = $_.Name
		Duration = $duration
		Milliseconds = ($duration.TotalMilliseconds.ToString())
	}))
}
$profiler.Report.HighestImpact = $profiler.Report.Actions | Sort-Object -Property Duration -Descending | Select-Object -First 1 | % { "$($_.Name) ($($_.Milliseconds) milliseconds)" }

$ProfileConfig.Temp.ModuleInitializationProfiler = $profiler