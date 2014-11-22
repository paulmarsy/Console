param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 1; Critical = $false}) }

$ProfileConfig.Module.Version.Update.Invoke()
if (-not $ProfileConfig.Module.Version.CurrentVersionInstalled) {
	Install-PowerShellConsole -AutomatedReinstall
}
