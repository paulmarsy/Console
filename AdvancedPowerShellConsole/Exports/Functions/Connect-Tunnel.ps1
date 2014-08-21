function Connect-Tunnel {
    [CmdletBinding(DefaultParameterSetName="Type")]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        $TunnelHost,
        [Parameter(Mandatory=$true,Position=1)]
        $DestinationHost,
        [Parameter(ParameterSetName="Type",Mandatory=$true,Position=2)][ValidateSet("RDC", "RDP", "SSH", "TELNET")]
        $DestinationType = "RDC",
        [Parameter(ParameterSetName="Port",Mandatory=$true,Position=2)]
        $DestinationPort,
        [switch]$LeaveTunnelOpen,
        $TunnelPort = $null,
        $TunnelUsername = $null,
        $TunnelPassword = $null,
        $DestinationUsername = $null,
        $DestinationPassword = $null
    )

     if ($PsCmdlet.ParameterSetName -eq "Type") {
    	switch ($DestinationType) {
    		 "RDC" { $DestinationPort = 3389 }
    		 "RDP" { $DestinationPort = 3389 }
    		 "SSH" { $DestinationPort = 22 }
    		 "TELNET" { $DestinationPort = 23 }
    	}
	}

	if ($null -eq $TunnelPort) { $TunnelPort = Get-Random -Minimum 10000 -Maximum 60000 }

    $plinkArguments = @($TunnelHost, "-C", "-N", "-v", "-L $("{0}:{1}:{2}" -f $TunnelPort, $DestinationHost, $DestinationPort)")
    if ($null -ne $TunnelUsername) { $plinkArguments += "-l `"$TunnelUsername`"" }
    if ($null -ne $TunnelPassword) { $plinkArguments += "-pw `"$TunnelPassword`"" }

    $process = Start-Process -FilePath "plink.exe" -ArgumentList $plinkArguments -PassThru

    if ($PsCmdlet.ParameterSetName -eq "Type") {
    	Write-Host "Press any key to continue once tunnel has been established..." -NoNewLine
    	$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    	Write-Host ("`nConnecting to {0}..." -f $DestinationHost)

    	$remoteArguments = @{"ComputerName" = "localhost"; "InteractiveType" = $DestinationType; "Port" = $TunnelPort}
   		if ($null -ne $DestinationUsername) { $remoteArguments += @{"Username" = "`"$DestinationUsername`"" } }
    	if ($null -ne $DestinationPassword) { $remoteArguments += @{"Password" = "`"$DestinationPassword`"" } }

    	Connect-Remote @remoteArguments
	} elseif ($PsCmdlet.ParameterSetName -eq "Port") {
		Write-Host ("Tunnel started on {0}:{1} routing to {2}:{3}" -f $env:COMPUTERNAME, $TunnelPort, $DestinationHost, $DestinationPort)
	}

	if (-not $LeaveTunnelOpen) {
    	Write-Host "`nPress any key to close tunnel..." -NoNewLine
    	$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null

    	$process | Stop-Process -Force

		Write-Host "`nTunnel closed"
	}
}