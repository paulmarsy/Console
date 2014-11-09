Invoke-InstallStep "Command Prompt" {
	New-Item "HKCU:\Console" -Force | Out-Null

	# Options
	New-ItemProperty "HKCU:\Console" "QuickEdit" -Value 1 -Type DWord -Force | Out-Null
	New-ItemProperty "HKCU:\Console" "InsertMode" -Value 1 -Type DWord -Force | Out-Null
	New-ItemProperty "HKCU:\Console" "CurrentPage" -Value 4 -Type DWord -Force | Out-Null

	# Font
	New-ItemProperty "HKCU:\Console" "FaceName" -Value "Consolas" -Type String -Force | Out-Null
	New-ItemProperty "HKCU:\Console" "FontFamily" -Value 0x36 -Type DWord -Force | Out-Null
	New-ItemProperty "HKCU:\Console" "FontWeight" -Value 0x190 -Type DWord -Force | Out-Null
	New-ItemProperty "HKCU:\Console" "FontSize" -Value 0xe0000 -Type DWord -Force | Out-Null

	# Layout
	New-ItemProperty "HKCU:\Console" "WindowSize" -Value 0x00230082 -Type DWord -Force | Out-Null
	New-ItemProperty "HKCU:\Console" "ScreenBufferSize" -Value 0x270f0082 -Type DWord -Force | Out-Null

	# Experimental
	New-ItemProperty "HKCU:\Console" "ForceV2" -Value 1 -Type DWord -Force | Out-Null

	New-ItemProperty "HKCU:\Console" "FilterOnPaste" -Value 1 -Type DWord -Force | Out-Null
	New-ItemProperty "HKCU:\Console" "LineWrap" -Value 1 -Type DWord -Force | Out-Null
	New-ItemProperty "HKCU:\Console" "CtrlKeyShortcutsDisabled" -Value 0 -Type DWord -Force | Out-Null
	New-ItemProperty "HKCU:\Console" "ExtendedEditKey" -Value 1 -Type DWord -Force | Out-Null
	New-ItemProperty "HKCU:\Console" "TrimLeadingZeros" -Value 0 -Type DWord -Force | Out-Null	

	New-ItemProperty "HKCU:\Console" "WindowAlpha" -Value 218 -Type DWord -Force | Out-Null
}