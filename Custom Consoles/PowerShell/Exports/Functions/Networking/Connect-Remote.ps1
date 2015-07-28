function Connect-Remote {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')] 
    param(
        [Parameter(Mandatory=$true,Position=0)]$ComputerName,
        [Parameter(Position=1)][ValidateSet("PowerShell", "RDP", "SSH", "TELNET", "VNC", "HTTP", "HTTPS")]$InteractiveType = "RDP",
        [Parameter(Position=2)][ValidateScript({ @("PowerShell") -contains $InteractiveType })]$Command,
        [switch]$UseWindowsLogon,
        [switch]$ResetWindowsLogon,
        $Port = $null,
        $Username = $null,
        $Password = $null
    )
    
    DynamicParam
    {
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    teCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]

        $defaultParameter = New-Object System.Management.Automation.ParameterAttribute
        $defaultParameter.ParameterSetName = "__AllParameterSets"
        $attributeCollection.Add($defaultParameter)

        if ($InteractiveType -eq "SSH") {
            $paramDictionary.Add('DontStartShell', (New-Object System.Management.Automation.RuntimeDefinedParameter('DontStartShell', [System.Diagnostics.Switch], $attributeCollection)))
            $paramDictionary.Add('RemoteCommand', (New-Object System.Management.Automation.RuntimeDefinedParameter('RemoteCommand', [System.String], $attributeCollection)))
        }

        return $paramDictionary
    }
    
    PROCESS {
        if ($ResetWindowsLogon) {
            Set-ProtectedProfileConfigSetting -Name "WindowsLogon" -Value ([string]::Empty) -Force
        }

        if ($UseWindowsLogon -or ($InteractiveType -eq "RDP" -and $null -eq $UserName -and $null -eq $Password)) {
            $windowsLogon = Get-ProtectedProfileConfigSetting -Name "WindowsLogon"
            if ([string]::IsNullOrWhiteSpace($windowsLogon)) {
                $windowsCredentials = Get-Credential -Username ("{0}\{1}" -f ([Environment]::UserDomainName), ([Environment]::UserName)) -Message "Enter your windows logon credentials"
                $windowsLogon = @{
                    UserName = $windowsCredentials.UserName
                    Password = $windowsCredentials.Password.Peek()
                }
                Set-ProtectedProfileConfigSetting -Name "WindowsLogon" -Value $windowsLogon -Force
            }
            $UserName = $windowsLogon.UserName
            $Password = $windowsLogon.Password
        }

        switch ($InteractiveType)
        {
            "PowerShell" {
                $parameters = @{ComputerName = $ComputerName}
                if ($null -ne $Port) { $parameters += @{"Port" = $Port} }
                if ($null -ne $Username -and $null -ne $Password) {
                    $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
                    $credentials = New-Object System.Management.Automation.PSCredential ($Username, $securePassword)
                    $parameters += @{"Credential" = $credentials}
                }
                if ($Command) {
                    $parameters += @{"ScriptBlock" = $Command}
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
           		New-ItemProperty $localDevicesPath $ComputerName -Value "111" -Type DWord -Force | Out-Null # Not sure what '111' means, can't find any documentation for it

                if ($null -ne $Username -and $null -ne $Password) {
                    Start-Process -FilePath "cmdkey.exe" -ArgumentList @("/generic:`"TERMSRV/$ComputerName`"", "/user:`"$Username`"", "/pass:`"$Password`"") -WindowStyle Hidden
                }

                Start-Thread -ScriptBlock {
                    param($InstallPath, $ComputerName, $Port, $Username, $Password)

                    $arguments = @("`"$(Join-Path $InstallPath 'Libraries\Resources\Default.rdp')`"")
                    if ($null -ne $Port) {
                        $arguments += "/v:`"$($ComputerName):$($Port)`""
                    } else {
                        $arguments += "/v:`"$($ComputerName)`""
                    }

                    Start-Process -FilePath "mstsc.exe" -ArgumentList $arguments -Wait

                    if ($null -ne $Username -and $null -ne $Password) {
                        Start-Process -FilePath "cmdkey.exe" -ArgumentList @("/delete:`"TERMSRV/$ComputerName`"") -WindowStyle Hidden
                    }
                } -ArgumentList @($ProfileConfig.Module.InstallPath, $ComputerName, $Port, $Username, $Password) | Out-Null # TODO: Clean up this job once it has finished somehow
            }
            "SSH" {
                $arguments = @($ComputerName)
                if ($null -ne $Port) { $arguments += "-P $Port" }
                if ($null -ne $Username) { $arguments += "-l `"$Username`"" }
                if ($null -ne $Password) { $arguments += "-pw `"$Password`"" }
                if (Test-Path Variable:DontStartShell) { $arguments += "-N" }
                if ((Test-Path Variable:RemoteCommand) -and -not ([string]::IsNullOrWhiteSpace((Get-Variable -Name RemoteCommand -ValueOnly)))) { $arguments += "-s $RemoteCommand" }

                Start-Process -FilePath "putty.exe" -ArgumentList $arguments
            }
            "TELNET" {
                if ($null -eq $Port) { $Port = 23 }

                & telnet ($(if ($null -ne $Username) { "-l $Username" })) $ComputerName $Port
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
                    $obfuscatedPassword = & (Join-Path $ProfileConfig.Module.InstallPath 'Libraries\Custom Helper Apps\VncPassword\vncpassword.exe') "$Password" | % {
                        [byte]::Parse($_, [System.Globalization.NumberStyles]::AllowHexSpecifier)
                    }
                    $passwordFile = [System.IO.Path]::GetTempFileName()
                    [System.IO.File]::WriteAllBytes($passwordFile, $obfuscatedPassword)
                    $arguments += "PasswordFile=`"$($passwordFile)`""
                } else {
                    $PasswordFile = $null
                }

                if ($null -ne $Port) { $arguments += "$($ComputerName):{0}" -f $Port }
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
                if ($null -eq $Port) { $Port = 80 }
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
                if ($null -eq $Port) { $Port = 443 }
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
