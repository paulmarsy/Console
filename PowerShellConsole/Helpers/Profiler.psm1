Set-StrictMode -Version Latest

$InstallPath = Get-Item -Path Env:\PowerShellConsoleInstallPath | % Value

$Profiler = @{
	RawData = ({@()}.Invoke())
}

$humanizerAssembly = Join-Path $InstallPath "Libraries\.NET Assemblies\Humanizer\Humanizer.dll"
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

	$now = Get-Date | % Ticks
	$lastStep = $Profiler.RawData | Select-Object -Last 1

	if ($Type -eq "Begin") {
		if ($null -ne $lastStep -and $null -eq $lastStep.Finish) {
			$lastStep.Finish = $now
		}

		$Profiler.RawData.Add((New-Object -TypeName PSObject -Property @{
			Name = $Name
			Start = $now
			Finish = $null
		}))
	} elseif ($Type -eq "End") {
		$lastStep.Finish = $now
	}
}

function Measure-ProfilerSteps {
	$totalTimeSpan = ([System.TimeSpan]::FromTicks((($Profiler.RawData | Select-Object -Last 1 | % Finish) - ($Profiler.RawData | Select-Object -First 1 | % Start))))
	$Profiler.Report = @{
		Actions = ({@()}.Invoke())
		TotalTime = $humanizeTimeSpan.Invoke($totalTimeSpan)
	}
	$Profiler.RawData | % {
		$durationTimeSpan = [System.TimeSpan]::FromTicks($_.Finish - $_.Start)
		$Profiler.Report.Actions.Add((New-Object -TypeName PSObject -Property @{
			Name = $_.Name
			Duration = $durationTimeSpan
			HumanDuration = $humanizeTimeSpan.Invoke($durationTimeSpan)
		}))
	}
	$Profiler.Report.HighestImpact = $Profiler.Report.Actions | Sort-Object -Property Duration -Descending | Select-Object -First 1 | % { "$($_.Name) - $($_.HumanDuration)" }
}

function Get-ProfilerResults {
	return $Profiler
}

function Show-ProfilerResults {
 	Measure-ProfilerSteps
	$Profiler.Report | % {
		Write-Host -ForegroundColor DarkMagenta "`tTotal time: $($_.TotalTime)"
		Write-Host -ForegroundColor DarkMagenta "`tHighest impact: $($_.HighestImpact)"
		$_.Actions | Format-Table -Property @(@{Label = "Name"; Expression = { $_.Name }} , @{Label = "Duration"; Expression = { $_.HumanDuration }}) -AutoSize | Out-Host
	}
}

Export-ModuleMember -Function @("Set-ProfilerStep", "Measure-ProfilerSteps", "Get-ProfilerResults", "Show-ProfilerResults")