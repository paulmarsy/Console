function Connect-Remote {
    [CmdletBinding(DefaultParameterSetName="Interactive")]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        $ComputerName,
        [ValidateSet("PowerShell", "RDC", "RDP", "SSH", "TELNET")][Parameter(ParameterSetName="Interactive",Position=1)]
        $InteractiveType = "PowerShell",
        $Port = $null,
        $Username = $null,
        $Password = $null
    )

    if ($InteractiveType -eq "PowerShell") {
        $parameters = @{}
        if ($null -ne $Port) { $parameters += @{"Port" = $Port} }
        if ($null -ne $Username -and $null -ne $Password) {
            $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
            $credentials = New-Object System.Management.Automation.PSCredential ($Username, $securePassword)
            $parameters += @{"Credential" = $credentials}
        }
        Enter-PSSession -ComputerName $ComputerName @parameters
    }
    elseif ($InteractiveType -eq "RDC" -or $InteractiveType -eq "RDP") {
    	$localDevicesPath = "HKCU:\Software\Microsoft\Terminal Server Client\LocalDevices"
    	if (-not (Test-Path $localDevicesPath)) {
   			New-Item $localDevicesPath -Force | Out-Null
   		}
   		$localDevices = Get-Item $localDevicesPath
   		if ($null -eq ($localDevices.GetValue($ComputerName))) {
   			# Automatically accept the security warning for new connections if it hasnt been seen before
   			New-ItemProperty $localDevicesPath $ComputerName -Value "5" -Type DWord -Force | Out-Null
   		}

        if ($null -eq $Port) { $Port = 3389 }
        if ($null -ne $Username -and $null -ne $Password) {
            & cmdkey /generic:TERMSRV/"$ComputerName" /user:"$Username" /pass:"$Password" | Out-Null
        }
    	
        & mstsc (Join-Path $InstallPath "Support Files\MSTSC\Default.rdp") /v:$("$($ComputerName):$($Port)")
    }
    elseif ($InteractiveType -eq "SSH") {
        if ($null -eq $Port) { $Port = 22 }
        $arguments = @($ComputerName, "-P $Port")
        if ($null -ne $Username) { $arguments += "-l `"$Username`"" }
        if ($null -ne $Password) { $arguments += "-pw `"$Password`"" }

        Start-Process -FilePath "putty.exe" -ArgumentList $arguments
    }
    elseif ($InteractiveType -eq "TELNET") {
        if ($null -eq $Port) { $Port = 23 }

        & telnet ($(if ($Username -ne $null) { "-l $Username" })) $ComputerName $Port
    }
}