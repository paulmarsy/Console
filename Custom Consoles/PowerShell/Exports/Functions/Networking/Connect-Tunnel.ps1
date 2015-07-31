function Connect-Tunnel {
    [CmdletBinding(DefaultParameterSetName="Type")]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        $TunnelHost,
        [Parameter(Mandatory=$true,Position=1)]
        $DestinationHost,
        [Parameter(ParameterSetName="Type",Mandatory=$true,Position=2)][ValidateSet("RDC", "RDP", "SSH", "TELNET", "HTTP", "HTTPS")]
        $DestinationType = "RDC",
        [Parameter(ParameterSetName="Port",Mandatory=$true,Position=2)]
        $DestinationPort,
        [switch]$LeaveTunnelOpen,
        $TunnelPort = $null,
        $TunnelUsername = $null,
        $TunnelPassword = $null,
        $LocalPort = $null,
        $DestinationUsername = $null,
        $DestinationPassword = $null
    )

     if ($PsCmdlet.ParameterSetName -eq "Type") {
    	switch ($DestinationType) {
    		 "RDC" { $DestinationPort = 3389 }
    		 "RDP" { $DestinationPort = 3389 }
    		 "SSH" { $DestinationPort = 22 }
    		 "TELNET" { $DestinationPort = 23 }
             "HTTP" { $DestinationPort = 80 }
             "HTTPS" { $DestinationPort = 443 }
    	}
	}

	if ($null -eq $LocalPort) { $LocalPort = Get-Random -Minimum 10000 -Maximum 60000 }

    $plinkArguments = @($TunnelHost, "-ssh", "-2", "-C", "-N", "-v", "-L $("127.0.0.1:{0}:{1}:{2}" -f $LocalPort, $DestinationHost, $DestinationPort)")
    if ($null -ne $TunnelPort) { $plinkArguments += "-P $TunnelPort" }
    if ($null -ne $TunnelUsername) { $plinkArguments += "-l `"$TunnelUsername`"" }
    if ($null -ne $TunnelPassword) { $plinkArguments += "-pw `"$TunnelPassword`"" }

    $process = Start-Process -FilePath "plink.exe" -ArgumentList $plinkArguments -PassThru

    if ($PsCmdlet.ParameterSetName -eq "Type") {
    	Write-Host "Press any key to continue once tunnel has been established..." -NoNewLine
    	$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    	Write-Host ("`nConnecting to {0}..." -f $DestinationHost)

    	$remoteArguments = @{"ComputerName" = "localhost"; "InteractiveType" = $DestinationType; "Port" = $LocalPort}
   		if ($null -ne $DestinationUsername) { $remoteArguments += @{"Username" = "`"$DestinationUsername`"" } }
    	if ($null -ne $DestinationPassword) { $remoteArguments += @{"Password" = "`"$DestinationPassword`"" } }

    	Connect-Remote @remoteArguments
	} elseif ($PsCmdlet.ParameterSetName -eq "Port") {
		Write-Host ("Tunnel started on {0}:{1} routing to {2}:{3}" -f $env:COMPUTERNAME, $LocalPort, $DestinationHost, $DestinationPort)
	}

	if (-not $LeaveTunnelOpen) {
    	Write-Host "`nPress any key to close tunnel..." -NoNewLine
    	$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null

    	$process | Stop-Process -Force

		Write-Host "`nTunnel closed"
	}
}