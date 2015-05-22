try {
    1..8 | % { Write-Host }
    Write-Host "Installing prerequisites..."
    
    . .\Invoke-Installer.ps1
    $innoInstallerArguments = @("/SILENT", "/NORESTART", "/CLOSEAPPLICATIONS", "/RESTARTAPPLICATIONS")
    
    if (# Microsoft Azure PowerShell  https://github.com/Azure/azure-powershell
        (Invoke-Installer -Name "Microsoft Azure PowerShell" -Uri "https://github.com/Azure/azure-powershell/releases/download/0.9.1-May2015/azure-powershell.0.9.1.msi" -Optional -Type msi) -and `
        # Git for Windows             https://github.com/git-for-windows/git
        (Invoke-Installer -Name "Git for Windows" -Uri "https://github.com/git-for-windows/git/releases/download/v2.4.1.windows.1/Git-2.4.1.1-dev-preview-64-bit.exe" -Type exe -ArgumentList ($innoInstallerArguments + @('/COMPONENTS=""', '/TASKS=""'))) -and `
        # GitHub for Windows          https://windows.github.com/
        (Invoke-Installer -Name "GitHub for Windows" -Uri "https://github-windows.s3.amazonaws.com/GitHubSetup.exe" -Type exe -ArgumentList @("/Force")) -and `
        # SmartGit                    http://www.syntevo.com/smartgit/
        (Invoke-Installer -Name "SmartGit" -Uri "http://www.syntevo.com/downloads/smartgit/smartgit-win32-setup-jre-6_5_8.zip" -Optional -Type exe -Zipped -ArgumentList ($innoInstallerArguments + @('/MERGETASKS="!desktopicon"'))) -and `
        # WinPcap                     http://www.winpcap.org/
        (Invoke-Installer -Name "WinPcap" -Uri "https://www.winpcap.org/install/bin/WinPcap_4_1_3.exe" -Optional -Type exe -ArgumentList @("/S", "/desktopicon=no", "/quicklaunchicon=no"))) {
            
            Write-Host -ForegroundColor Green "Installation succeeded!"
    } else {
            Write-Host -ForegroundColor Red "Installation failed!"
    }
}
catch {
    Write-Host -ForegroundColor Red "Installation failed:"
    Write-Host -ForegroundColor Red $_
}