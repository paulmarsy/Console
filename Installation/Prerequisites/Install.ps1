try {
    . .\Invoke-Installer.ps1
    
    $innoInstallerArguments = @("/SILENT", "/NORESTART", "/CLOSEAPPLICATIONS", "/RESTARTAPPLICATIONS")
    
    if (# Microsoft Azure PowerShell  https://github.com/Azure/azure-powershell
        (Invoke-Installer -Name "Microsoft Azure PowerShell" -Uri "http://az412849.vo.msecnd.net/downloads04/azure-powershell.0.8.16.msi" -Type msi) -and `
        # Git for Windows             http://git-scm.com/download/win
        (Invoke-Installer -Name "Git for Windows" -Uri "https://github.com/msysgit/msysgit/releases/download/Git-1.9.5-preview20150319/Git-1.9.5-preview20150319.exe" -Type exe -ArgumentList ($innoInstallerArguments + @('/COMPONENTS=""', '/TASKS=""'))) -and `
        # GitHub for Windows          https://windows.github.com/
        (Invoke-Installer -Name "GitHub for Windows" -Uri "https://github-windows.s3.amazonaws.com/GitHubSetup.exe" -Type exe -ArgumentList @("/Force")) -and `
        # SmartGit                    http://www.syntevo.com/smartgit/
        (Invoke-Installer -Name "SmartGit" -Uri "http://www.syntevo.com/downloads/smartgit/smartgit-win32-setup-jre-6_5_7.zip" -Type exe -Zipped -ArgumentList ($innoInstallerArguments + @('/MERGETASKS="!desktopicon"'))) -and `
        # WinPcap                     http://www.winpcap.org/
        (Invoke-Installer -Name "WinPcap" -Uri "https://www.winpcap.org/install/bin/WinPcap_4_1_3.exe" -Type exe -ArgumentList @("/S", "/desktopicon=no", "/quicklaunchicon=no"))) {
            Write-Host -ForegroundColor Green "Installation succeeded!"
    } else {
            Write-Host -ForegroundColor Red "Installation has failed!"
    }
}
catch {
    Write-Host -ForegroundColor Red "Installation has failed:"
    Write-Host -ForegroundColor Red $_
    (Get-Host).SetShouldExit(1)
}