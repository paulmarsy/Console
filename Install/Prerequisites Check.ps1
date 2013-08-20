"Checking for prerequisites"

if ([System.Environment]::Is64BitOperatingSystem) {
    $path = @(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
        'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
        'HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
} else {
    $path = @(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
}

$installedPrograms = $path | ? { Test-Path $_ } | Get-ItemProperty | ? { $_.DisplayName } | % { $_.DisplayName }

$allPreRequisitesMet = $true

function _checkForInstall {
    param(
        $filter,
        $notInstalledMessage
    )

    if (-not ($installedPrograms | ? { $_ -like $filter })) {
        Write-Host -ForgroundColor Red "Prerequisite not installed: $notInstalledMessage"
        $allPreRequisitesMet = $false
    }
}

_checkForInstall "GitHub" "GitHub for Windows - http://windows.github.com/"

_checkForInstall "Git version *" "Git for Windows - http://msysgit.github.io/"

# Microsoft Team Foundation Server 2012 Power Tools
#Get-PSSnapin -Name "Microsoft.TeamFoundation.PowerShell" -Registered


_checkForInstall "Windows Azure Powershell - *" "Windows Azure PowerShell - https://github.com/WindowsAzure/azure-sdk-tools"