Invoke-InstallStep "Accepting Sysinternals EULA" {
	$sysinternalsDir = Join-Path $PowerShellConsoleConstants.InstallPath "Libraries\Binaries\Sysinternals"

	New-Item "HKCU:\Software\Sysinternals" -Force | Out-Null

	$specialEulaKeys = @(	'procexp',			'procmon')
	$additionalEulaKeys = @('Process Explorer',	'Process Monitor')

	(Get-ChildItem $sysinternalsDir -Filter *.exe | ? { $specialEulaKeys -inotcontains $_.BaseName } | % { $_.BaseName }) `
	+ $additionalEulaKeys | % {
		New-Item "HKCU:\Software\Sysinternals\$_" -Force | Out-Null
		New-ItemProperty "HKCU:\Software\Sysinternals\$_" "EulaAccepted" -Value "1" -Type DWord -Force | Out-Null
	}
}