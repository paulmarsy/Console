function Connect-Remote {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')] 
    param(
        [Parameter(Mandatory=$true, Position=1)][System.String]$ComputerName,
        [Parameter(Mandatory=$false, Position=2)][ValidateSet("PowerShell", "RDP", "SSH", "TELNET", "VNC", "HTTP", "HTTPS")][System.String]$InteractiveType = "RDP",
        [AllowNull()][System.UInt16]$Port = 0,
        [System.String]$Username = $null,
		[System.String]$Password = $null,
        [switch]$UseWindowsLogon
    )
    
    DynamicParam
    {
    	if (-not (Test-Path Variable:InteractiveType)) { return }
    	
        $runtimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        switch ($InteractiveType) {            
            "SSH" {
                New-DynamicParam -Name DontStartShell -Type ([System.Management.Automation.SwitchParameter]) -DPDictionary $runtimeParameterDictionary
                New-DynamicParam -Name RemoteCommand -Type ([System.String]) -DPDictionary $runtimeParameterDictionary
                New-DynamicParam -Name KeyFile -Type ([System.String]) -DPDictionary $runtimeParameterDictionary
            }
            "PowerShell" {
                New-DynamicParam -Name RemoteCommand -Type ([System.String]) -DPDictionary $runtimeParameterDictionary
            }
        }
        return $runtimeParameterDictionary
    }
    
    PROCESS {
        if ($UseWindowsLogon -or ($InteractiveType -eq "RDP" -and $null -eq $UserName -and $null -eq $Password)) {
            $windowsLogon = Get-RemoteAccessCredential
            if ([string]::IsNullOrWhiteSpace($windowsLogon)) {
                Write-Warning "Unable to access stored Windows Credentials for remote access try 'Set-RemoteAccessCredentials'"
                return
            }
            $UserName = $windowsLogon.UserName
            $Password = $windowsLogon.Password
        }

        switch ($InteractiveType)
        {
            "PowerShell" {
                $parameters = @{ComputerName = $ComputerName}
                if (0 -ne $Port) { $parameters += @{"Port" = $Port} }
                if ($null -ne $Username -and $null -ne $Password) {
                    $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
                    $credentials = New-Object System.Management.Automation.PSCredential ($Username, $securePassword)
                    $parameters += @{"Credential" = $credentials}
                }
                if (Test-Path Variable:RemoteCommand) {
                    $parameters += @{"ScriptBlock" = $RemoteCommand}
                    Invoke-Command @parameters
                } else {
                    Enter-PSSession @parameters
                }
            }
            "RDP" {
            	$localDevicesPath = "HKCU:\Software\Microsoft\Terminal Server Client\LocalDevices"
            	if (-not (Test-Path $localDevicesPath)) {
           			New-Item $localDevicesPath -Force | Out-Null
           		}
           		New-ItemProperty $localDevicesPath $ComputerName -Value 0x26f -Type DWord -Force | Out-Null

                if ($null -ne $Username -and $null -ne $Password) {
                    Start-Process -FilePath "cmdkey.exe" -ArgumentList @("/generic:`"TERMSRV/$ComputerName`"", "/user:`"$Username`"", "/pass:`"$Password`"") -WindowStyle Hidden -Wait
                }
                
                $arguments = @("`"$(Join-Path $ProfileConfig.Module.InstallPath 'Libraries\Resources\Default.rdp')`"")
                if (0 -ne $Port) {
                    $arguments += "/v:`"$($ComputerName):$($Port)`""
                } else {
                    $arguments += "/v:`"$($ComputerName)`""
                }

                Start-Thread -ScriptBlock {
                    param($ArgumentList, $ComputerName, $Username, $Password, $LocalDevicesPath)

                    Start-Process -FilePath "mstsc.exe" -ArgumentList $ArgumentList -Wait

                    Remove-ItemProperty $LocalDevicesPath $ComputerName -Force | Out-Null

                    if ($null -ne $Username -and $null -ne $Password) {
                        Start-Process -FilePath "cmdkey.exe" -ArgumentList @("/delete:`"TERMSRV/$ComputerName`"") -WindowStyle Hidden
                    }
                } -ArgumentList @($arguments, $ComputerName, $Username, $Password, $localDevicesPath) | Out-Null # TODO: Clean up this job once it has finished somehow
            }
            "SSH" {
                $arguments = @($ComputerName, "-agent")
                if (0 -ne $Port) { $arguments += "-P $Port" }
                if ($null -ne $Username) { $arguments += "-l `"$Username`"" }
                if ($null -ne $Password) { $arguments += "-pw `"$Password`"" }
                if (Test-Path Variable:DontStartShell) { $arguments += "-N" }
                if ((Test-Path Variable:RemoteCommand) -and -not ([string]::IsNullOrWhiteSpace((Get-Variable -Name RemoteCommand -ValueOnly)))) { $arguments += "-s $RemoteCommand" }
                if ((Test-Path Variable:KeyFile) -and (Test-Path (Get-Variable -Name KeyFile -ValueOnly))) { $arguments += "-i `"$KeyFile`"" }

                Start-Process -FilePath "putty.exe" -ArgumentList $arguments
            }
            "TELNET" {
                $arguments = @()
                if ($null -ne $Username) { "-l $Username" }
                $arguments += $ComputerName
                if (0 -ne $Port) { $arguments += $Port }

                Start-Process -FilePath (Join-Path $env:windir "system32\telnet.exe") -ArgumentList $arguments -NoNewLine
            }
            "VNC" {
                $vncExecutable = Join-Path $ProfileConfig.Module.InstallPath 'Libraries\Misc\VNC-Viewer-5.2.3-Windows-64bit.exe'
                if (-not (Test-Path $vncExecutable)) {
                    throw "Unable to find VNC Viewer executable"
                }

                $arguments = @("WarnUnencrypted=0", "EnableChat=0", "EnableRemotePrinting=0", "SecurityNotificationTimeout=0")
                if ($null -ne $UserName) {
                    $arguments += "UserName=`"$($UserName)`""
                }
                
                if ($null -ne $Password) {
                    $vncpasswordApp = switch ([System.Environment]::Is64BitOperatingSystem) {
                        $true { "vncpassword-x64.exe" }
                        $false { "vncpassword-x86.exe" }
                    }
                    $obfuscatedPassword = & ([System.IO.Path]::Combine($ProfileConfig.Module.InstallPath, 'Libraries\Custom Helper Apps\VncPassword', $vncpasswordApp)) "$Password" | % {
                        [byte]::Parse($_, [System.Globalization.NumberStyles]::AllowHexSpecifier)
                    }
                    $passwordFile = [System.IO.Path]::GetTempFileName()
                    [System.IO.File]::WriteAllBytes($passwordFile, $obfuscatedPassword)
                    $arguments += "PasswordFile=`"$($passwordFile)`""
                } else {
                    $PasswordFile = $null
                }

                if (0 -ne $Port) { $arguments += "$($ComputerName):{0}" -f $Port }
                else { $arguments += $ComputerName }

                Start-Thread -ScriptBlock {
                    param($vncExecutable, $arguments, $passwordFile)

                    Start-Process -FilePath $vncExecutable -ArgumentList $arguments -Wait

                    if ($null -ne $passwordFile -and (Test-Path $passwordFile)) {
                        Remove-Item -Path $passwordFile -Force
                    }
                } -ArgumentList @($vncExecutable, $arguments, $passwordFile) | Out-Null
            }
            "HTTP" {
                if (0 -eq $Port) { $Port = 80 }
                $prefix = [string]::Empty
                if ($null -ne $Username -or $null -ne $Password) {
                    if ($null -ne $Username) { $prefix = $Username }
                    $prefix += ":"
                    if ($null -ne $Password) { $prefix += $Password }
                    $prefix += "@"
                }
                
                Open-UrlWithDefaultBrowser -Url ("http://{0}{1}:{2}/" -f $prefix, $ComputerName, $Port)
            }
            "HTTPS" {
                if (0 -eq $Port) { $Port = 443 }
                $prefix = [string]::Empty
                if ($null -ne $Username -or $null -ne $Password) {
                    if ($null -ne $Username) { $prefix = $Username }
                    $prefix += ":"
                    if ($null -ne $Password) { $prefix += $Password }
                    $prefix += "@"
                }
                
                Open-UrlWithDefaultBrowser -Url ("https://{0}{1}:{2}/" -f $prefix, $ComputerName, $Port)
            }
        }
    }
}
