$ProfileConfig.Module.Version.Update.Invoke()
if (-not $ProfileConfig.Module.Version.CurrentVersionInstalled) {
	Install-PowerShellConsole -AutomatedReinstall
}
