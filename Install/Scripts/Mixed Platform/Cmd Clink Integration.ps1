Invoke-InstallStep "Cmd Clink Integration" {
	$clinkBaseFile = Join-Path $InstallPath "Console\ConEmu\clink\clink_"
	New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Command Processor" "Autorun" -Value """$($clinkBaseFile)x64.exe"" inject" -Type String -Force | Out-Null
	New-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Command Processor" "Autorun" -Value """$($clinkBaseFile)x86.exe"" inject" -Type String -Force | Out-Null
}