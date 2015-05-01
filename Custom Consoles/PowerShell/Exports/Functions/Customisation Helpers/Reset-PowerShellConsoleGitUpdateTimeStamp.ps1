function Reset-PowerShellConsoleGitUpdateTimeStamp {
    $ProfileConfig.Git.LastAutoSyncTickTime = 0
    Save-ProfileConfig
    
    $lastSync = New-Object -Type System.DateTime -ArgumentList $ProfileConfig.Git.LastAutoSyncTickTime
    $nextSyncAfter = $lastSync.AddSeconds($ProfileConfig.Git.SyncIntervalInSeconds)
    Write-Host "Last sync time set to: $lastSync, next sync after $nextSyncAfter"
}