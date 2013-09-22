Invoke-InstallStep "Configuring Console Visual Studio Integration" {
	New-Item "HKCU:\Software\Microsoft\VisualStudio\11.0\DialogPage\GrzegorzKozub.VisualStudioExtensions.ConEmuLauncher.Options" -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Microsoft\VisualStudio\11.0\DialogPage\GrzegorzKozub.VisualStudioExtensions.ConEmuLauncher.Options" "Path" -Value "$conEmuExecutable" -Type String -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Microsoft\VisualStudio\11.0\DialogPage\GrzegorzKozub.VisualStudioExtensions.ConEmuLauncher.Options" "DefaultWorkingDirectory" -Value "%HOMEDRIVE%%HOMEPATH%" -Type String -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Microsoft\VisualStudio\11.0\DialogPage\GrzegorzKozub.VisualStudioExtensions.ConEmuLauncher.Options" "CommandLineOptions" -Value "" -Type String -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Microsoft\VisualStudio\11.0\DialogPage\GrzegorzKozub.VisualStudioExtensions.ConEmuLauncher.Options" "ReuseExistingInstance" -Value "Yes" -Type String -Force | Out-Null
	New-ItemProperty "HKCU:\Software\Microsoft\VisualStudio\11.0\DialogPage\GrzegorzKozub.VisualStudioExtensions.ConEmuLauncher.Options" "TaskToExecute" -Value "" -Type String -Force | Out-Null
}