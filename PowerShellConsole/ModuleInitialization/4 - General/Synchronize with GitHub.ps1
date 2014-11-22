param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

Sync-ConsoleWithGitHub -DontPushToGitHub -UpdateConsole Auto -Quiet -AutoSync