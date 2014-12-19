Invoke-InstallStep "Configuring Console Visual Studio Integration" {
	New-Item "HKCU:\Software\Microsoft\VisualStudio\12.0\DialogPage\GrzegorzKozub.VisualStudioExtensions.ConEmuLauncher.Options" -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Microsoft\VisualStudio\12.0\DialogPage\GrzegorzKozub.VisualStudioExtensions.ConEmuLauncher.Options" "Path" -Value $PowerShellConsoleConstants.Executables.ConEmu -Type String -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Microsoft\VisualStudio\12.0\DialogPage\GrzegorzKozub.VisualStudioExtensions.ConEmuLauncher.Options" "DefaultWorkingDirectory" -Value "$($env:HOMEDRIVE)\" -Type String -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Microsoft\VisualStudio\12.0\DialogPage\GrzegorzKozub.VisualStudioExtensions.ConEmuLauncher.Options" "CommandLineOptions" -Value "" -Type String -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Microsoft\VisualStudio\12.0\DialogPage\GrzegorzKozub.VisualStudioExtensions.ConEmuLauncher.Options" "ReuseExistingInstance" -Value "Yes" -Type String -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Microsoft\VisualStudio\12.0\DialogPage\GrzegorzKozub.VisualStudioExtensions.ConEmuLauncher.Options" "TaskToExecute" -Value "PowerShell" -Type String -Force | Out-Null
}