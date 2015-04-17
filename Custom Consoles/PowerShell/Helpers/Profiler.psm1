Set-StrictMode -Version Latest

$InstallPath = Get-Item -Path Env:\CustomConsolesInstallPath | % Value

$ModuleInitProfilerData = ({@()}.Invoke())

$humanizerAssembly = Join-Path $InstallPath "Libraries\Misc\Humanizer.dll"
if (Test-Path $humanizerAssembly) {
	Add-Type -Path $humanizerAssembly
	$humanizeTimeSpan = {
		param($timeSpan)
		return [Humanizer.TimeSpanHumanizeExtensions]::Humanize($timeSpan, 2)
	}
} else {
	$humanizeTimeSpan = {
		param($timeSpan)
		return ("{0}ms" -f ([System.Math]::Round($durationTimeSpan.TotalMilliseconds, 2)))
	}
}

function Set-ProfilerStep {
	param(
		[Parameter(Position = 0, Mandatory = $true)][ValidateSet("Begin", "End")]$Type,
		[Parameter(Position = 1, ValueFromRemainingArguments = $true)]$Name
	)

	$now = [System.Diagnostics.Stopwatch]::GetTimestamp()
	$lastStep = $ModuleInitProfilerData | Select-Object -Last 1

	if ($Type -eq "Begin") {
		if ($null -ne $lastStep -and $null -eq $lastStep.Finish) {
			$lastStep.Finish = $now
		}

		$ModuleInitProfilerData.Add((New-Object -TypeName PSObject -Property @{
			Name = $Name
			Start = $now
			Finish = $null
		}))
	} elseif ($Type -eq "End") {
		$lastStep.Finish = $now
	}
}

function Show-ProfilerResults {
	param(
		[switch]$OrderByDuration
	)

	$totalTimeSpan = ([System.TimeSpan]::FromTicks((($ModuleInitProfilerData | Select-Object -Last 1 | % Finish) - ($ModuleInitProfilerData | Select-Object -First 1 | % Start))))
	$report = @{
		Actions = ({@()}.Invoke())
		TotalTime = $humanizeTimeSpan.Invoke($totalTimeSpan)
	}
	$ModuleInitProfilerData | % {
		$durationTimeSpan = [System.TimeSpan]::FromTicks($_.Finish - $_.Start)
		$report.Actions.Add((New-Object -TypeName PSObject -Property @{
			Name = $_.Name
			Duration = $durationTimeSpan
			HumanDuration = $humanizeTimeSpan.Invoke($durationTimeSpan)
		}))
	}

	Write-Host -ForegroundColor DarkMagenta "`tTotal time: $($report.TotalTime)"
	Write-Host -ForegroundColor DarkMagenta "`tTop 5 highest impact:"
	Write-Host
	$i = 0
	$report.Actions | 
		Sort-Object -Property Duration -Descending | 
		Select-Object -First 3 |
		% { $i++; Write-Host -ForegroundColor DarkMagenta ("`t {0}: {1} - {2}" -f $i, ($_.Name | Write-Output), ($_.HumanDuration | Write-Output)) }

	({
		if ($OrderByDuration) { $report.Actions | Sort-Object -Property Duration -Descending }
		else { $report.Actions }
	}.Invoke()) | Format-Table -Property @(@{Label = "Name"; Expression = { $_.Name }} , @{Label = "Duration"; Expression = { $_.HumanDuration }}) -AutoSize | Out-Host
}

Export-ModuleMember -Function @("Set-ProfilerStep", "Show-ProfilerResults")