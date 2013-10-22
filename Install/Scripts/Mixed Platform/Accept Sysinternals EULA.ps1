Invoke-InstallStep "Accepting Sysinternals EULA" {
	$sysinternalsDir = Join-Path $InstallPath "Third Party\Binaries\Sysinternals"

	New-Item "HKCU:\Software\Sysinternals" -Force | Out-Null

	Get-ChildItem $sysinternalsDir -Filter *.exe | % { $_.BaseName } | % {
		New-Item "HKCU:\Software\Sysinternals\$_" -Force | Out-Null
		New-ItemProperty "HKCU:\Software\Sysinternals\$_" "EulaAccepted" -Value "1" -Type DWord -Force | Out-Null
	}
}