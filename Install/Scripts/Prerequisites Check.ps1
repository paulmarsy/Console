$installedPrograms = & {    if ([System.Environment]::Is64BitOperatingSystem) {
                                @(
                                    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
                                    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
                                    'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
                                    'HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
                                )
                            } else {
                                @(
                                    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
                                    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
                                )
                            }} | ? { Test-Path $_ } | Get-ItemProperty | ? { ($_ | Get-Member | % { $_.Name }) -contains "DisplayName" } | % { $_.DisplayName }

$allPreRequisitesMet = $true

function _genericCheck {
    param($filter, $description, $downloadUrl)
    
    Write-Host "Checking for: $description..."
    if (& $filter) {
        Write-Host "$description not installed, please downnload from: $downloadUrl"
        $script:allPreRequisitesMet = $false
    }
}

function _checkForInstall {
    param($name, $description, $downloadUrl)

    _genericCheck { $null -eq ($installedPrograms | ? { $_ -like $name }) } $description $downloadUrl
}

function _checkForSnapin {
    param($name, $description, $downloadUrl)

    _genericCheck { $null -eq (Get-PSSnapin -Registered | ? { $_.Name -eq $name }) } $description $downloadUrl
}

_checkForInstall    "GitHub" `
                    "GitHub for Windows" `
                    "http://windows.github.com/"

_checkForInstall    "Git version *" `
                    "Git for Windows" `
                    "http://msysgit.github.io/"

_checkForInstall    "Windows Azure Powershell - *" `
                    "Windows Azure PowerShell" `
                    "https://github.com/WindowsAzure/azure-sdk-tools"

_checkForSnapin     "Microsoft.TeamFoundation.PowerShell" `
                    "Microsoft Team Foundation Server 2012 Power Tools" `
                    "http://visualstudiogallery.msdn.microsoft.com/b1ef7eb2-e084-4cb8-9bc7-06c3bad9148f"

return $allPreRequisitesMet