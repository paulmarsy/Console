Invoke-InstallStep "Calculator - Enabling digit grouping, programmer mode and converting units" {
	New-ItemProperty "HKCU:\Software\Microsoft\Calc" "UseSep" -Value 1 -Type DWord -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Microsoft\Calc" "layout" -Value 2 -Type DWord -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Microsoft\Calc" "UnitConv" -Value 1 -Type DWord -Force | Out-Null
}
