param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = -1; Critical = $true}) }

$onIdleCollection = @{
	MinimumReprocessTime = ([System.TimeSpan]::FromMinutes(3))

	UserIdleTimeThreshold = ([System.TimeSpan]::FromSeconds(2).TotalMilliseconds)
	UserIdleCountThreshold = 2

	ProcessorUsageThreshold = 1
	
	DontRunBefore = (Get-Date)
	ElapsedCount = 0
	IdleCount = 0
	TotalProcessorTime = 0
	
	IdleCheck = (Join-Path $ProfileConfig.Module.InstallPath "Libraries\Custom Helper Apps\IdleCheck\IdleCheck.exe")
	Timer = (New-Object -TypeName System.Timers.Timer -ArgumentList ([System.TimeSpan]::FromSeconds(10).TotalMilliseconds))
}

Register-ObjectEvent -InputObject $onIdleCollection.Timer -EventName Elapsed -SourceIdentifier CustomPowerShellConsoleIdleTimer -SupportEvent -Action {
	$onIdle = $Event.MessageData
	if ($onIdle.DontRunBefore.Ticks -ge (Get-Date | Select-Object -ExpandProperty Ticks)) { return }

	# Elapsed Count
	$onIdle.ElapsedCount++
	Write-Output "Elapsed count since last execution: $($onIdle.ElapsedCount)"
	# Elapsed Count

	# User Idle Time
	$userIdleTime = & $onIdle.IdleCheck
	if ($LASTEXITCODE -ne 0) { return }

	if (([int]$userIdleTime) -ge ([int]$onIdle.UserIdleTimeThreshold)) { $onIdle.IdleCount++ }
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
} -MessageData $onIdleCollection

$onIdleCollection.Timer.Enabled = $true