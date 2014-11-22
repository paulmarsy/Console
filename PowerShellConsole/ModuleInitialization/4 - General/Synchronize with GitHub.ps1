param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return 1 }

Sync-ConsoleWithGitHub -DontPushToGitHub -UpdateConsole Auto -Quiet -AutoSync