param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = -1; Critical = $true}) }

$onIdle = @{
	MinimumReprocessTime = ([System.TimeSpan]::FromMinutes(5))

	UserIdleTimeThreshold = ([System.TimeSpan]::FromSeconds(3).TotalMilliseconds)
	UserIdleCountThreshold = 2

	ProcessorUsageThreshold = 1
	
	DontRunBefore = (Get-Date)
	ElapsedCount = 0
	IdleCount = 0
	TotalProcessorTime = 0
	
	IdleCheck = (Join-Path $ProfileConfig.Module.InstallPath "Libraries\Custom Helper Apps\IdleCheck\IdleCheck.exe")
	IdleCheckTimeout = ([System.TimeSpan]::FromSeconds(1).TotalMilliseconds)
	Timer = (New-Object -TypeName System.Timers.Timer -ArgumentList ([System.TimeSpan]::FromSeconds(10).TotalMilliseconds))
}

Get-EventSubscriber -Force | ? SourceIdentifier -eq "CustomPowerShellConsoleIdleTimer" | Unregister-Event -Force
Register-ObjectEvent -InputObject $onIdle.Timer -EventName Elapsed -SourceIdentifier CustomPowerShellConsoleIdleTimer -SupportEvent -Action {
	$onIdle = $Event.MessageData
	if ($onIdle.DontRunBefore.Ticks -ge (Get-Date | Select-Object -ExpandProperty Ticks)) { return }

	# Elapsed Count
	$onIdle.ElapsedCount++
	Write-Output "Elapsed count since last execution: $($onIdle.ElapsedCount)"
	# Elapsed Count

	# User Idle Time
	$userIdleTimeProcess = [System.Diagnostics.Process]::Start((New-Object -TypeName System.Diagnostics.ProcessStartInfo -Property @{
		FileName = $onIdle.IdleCheck
		CreateNoWindow = $true
		UseShellExecute = $false
		RedirectStandardOutput = $true
	})) 
	if (-not $userIdleTimeProcess.WaitForExit($onIdle.IdleCheckTimeout)) { return }
	if ($userIdleTimeProcess.ExitCode -ne 0) { return }

	$userIdleTime = [int]($userIdleTimeProcess.StandardOutput.ReadToEnd().Trim())
	if ($userIdleTime -ge ([int]$onIdle.UserIdleTimeThreshold)) { $onIdle.IdleCount++ }
	else { $onIdle.IdleCount = 0; $onIdle.TotalProcessorTime = 0 }

	Write-Output "User idle count: $($onIdle.IdleCount) (Idle time: $userIdleTime; Threshold $($onIdle.UserIdleTimeThreshold))"
	if ($onIdle.IdleCount -lt $onIdle.UserIdleCountThreshold) { return }
	# User Idle Time

	# Processor Usage
	$totalProcessorTime = [System.Math]::Truncate([System.Diagnostics.Process]::GetCurrentProcess().TotalProcessorTime.TotalSeconds)
	$previousTotalProcessorTime = $onIdle.TotalProcessorTime
	$processorUsage =  $totalProcessorTime - $previousTotalProcessorTime
	$onIdle.TotalProcessorTime = $totalProcessorTime

	Write-Output "Processor usage: $($processorUsage) (Threshold $($onIdle.ProcessorUsageThreshold))"
	if ($processorUsage -gt $onIdle.ProcessorUsageThreshold) { return }
	# Processor Usage

	Write-Output "On Idle conditions met"
	$Global:OnIdleScriptBlockCollection | % { 
		try { $_.Invoke() }
		catch { Write-Error $_.Message }
	}

	Write-Output "On Idle ScriptBlocks executed. Resetting conditions."
	$onIdle.DontRunBefore = (Get-Date).Add($onIdle.MinimumReprocessTime)
	$onIdle.ElapsedCount = 0
	$onIdle.IdleCount = 0
	$onIdle.TotalProcessorTime = 0
} -MessageData $onIdle

$onIdle.Timer.Enabled = $true