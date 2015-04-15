function Reset-PowerShellConsoleGitUpdateTimeStamp {
    $ProfileConfig.Git.LastAutoSyncTickTime = 0
    Save-ProfileConfig
}