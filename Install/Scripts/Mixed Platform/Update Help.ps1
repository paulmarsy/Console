$proceed = Confirm-InstallSetting "Do you want to update Windows PowerShell's help?"

if ($proceed) {
	Invoke-InstallStep "Updating help" {
		Update-Help -Force
	}
}