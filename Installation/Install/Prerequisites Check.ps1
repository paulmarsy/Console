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
                            }} | ? { Test-Path $_ } | Get-ItemProperty | ? { ($_ | Get-Member | % Name) -contains "DisplayName" } | % DisplayName

$script:failedPrerequisites = 0

function genericCheck {
    param(
    	[Parameter(Position=0)]$predicate,
    	[Parameter(Position=1)]$checkDescription,
    	[Parameter(Position=2)]$failMessage,
    	[Parameter(Position=3)][switch]$Optional
    )

    Write-InstallMessage $checkDescription
    if (-not (& $predicate)) {
        Write-InstallMessage -Type $(?: { $Optional } { "Warning" } { "Error" }) $failMessage
        if (-not $Optional) { $script:failedPrerequisites++ }
    }
}

function checkForFile {
    param ($PathToFile, $FileName, [switch]$Optional)

    $resolvedPathToFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($PathToFile)
    genericCheck {
        Test-Path $resolvedPathToFile
    } "Checking for required file $FileName" "$FileName cannot be found at the location $resolvedPathToFile" $Optional
}

function checkForInstall {
    param($name, $Description, $DownloadUrl, [switch]$Optional)

    genericCheck {
    	$null -ne ($installedPrograms | ? { $_ -like $name })
    } "Checking for: $Description" "$Description not installed, please downnload from: $DownloadUrl or look in 'Install Files'" $Optional
}

function checkForSnapin {
    param($name, $Description, $DownloadUrl, [switch]$Optional)

    genericCheck {
    	$null -ne (Get-PSSnapin -Registered | ? { $_.Name -eq $name })
    } $Description $DownloadUrl $Optional
}

function checkForPendingReboot {
	param([switch]$Optional)

   genericCheck {
     if ($null -ne (@(
         "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing"
         "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"
         "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager"
       ) | Get-ChildItem | ? PSChildName -In @("RebootPending", "RebootRequired", "PendingFileRenameOperations"))) {
         return $false
     }
     if ($true -eq (New-Object -ComObject "Microsoft.Update.SystemInfo").RebootRequired) {
        return $false
     }

    return $true
  } "Checking for required pending reboot" "A pending reboot is required before installation can continue" $Optional
}

checkForPendingReboot -optional

checkForInstall		"Git version *" `
					"Git for Windows" `
					"http://msysgit.github.io/"

checkForInstall		"GitHub" `
					"GitHub for Windows" `
					"http://windows.github.com/" `
					-optional

checkForInstall		"Microsoft Azure PowerShell -*" `
					"Microsoft Azure PowerShell" `
					"https://github.com/WindowsAzure/azure-sdk-tools" `
                    -optional
                    
checkForInstall     "SmartGit*" `
                    "SmartGit" `
                    "http://www.syntevo.com/smartgit/" `
                    -optional

checkForInstall     "WinPcap *" `
                    "WinPcap" `
                    "http://www.winpcap.org/" `
                    -optional

return $script:failedPrerequisites
