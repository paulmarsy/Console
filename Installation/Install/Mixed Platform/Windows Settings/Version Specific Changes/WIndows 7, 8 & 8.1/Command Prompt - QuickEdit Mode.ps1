Invoke-InstallStep "Command Prompt - QuickEdit Mode" {
	New-ItemProperty "HKCU:\Console" "QuickEdit" -Value 1 -Type DWord -Force | Out-Null
}