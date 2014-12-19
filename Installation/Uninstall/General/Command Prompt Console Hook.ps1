Invoke-InstallStep "Removing Command Prompt Console Hook" {
	Remove-ItemProperty "HKCU:\Software\Microsoft\Command Processor" "AutoRun" -Force -ErrorAction Ignore
}