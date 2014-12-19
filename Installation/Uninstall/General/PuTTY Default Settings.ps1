Invoke-InstallStep "Resetting PuTTY Settings" {
	if (Test-Path "HKCU:\Software\SimonTatham\PuTTY\Sessions\Default%20Settings") {
		Remove-Item "HKCU:\Software\SimonTatham\PuTTY\Sessions\Default%20Settings" -Force
	}
}