function Show-NetworkStats
{
	param(
		[ValidateSet("IPv4", "IPv6")]$Version = "IPv4",
		[switch]$IncludeInactive
	)

	function WriteHeader {
		param(
			$Header,
			[ValidateSet("Main", "Section", "SubSection")]$Type = "SubSection"
		)
		
		switch ($Type){
			"Main" {
				DrawLine -Length 100
				Write-Host -ForegroundColor Red "`t`t`t`t$Header"
				DrawLine -Length 100
				Write-Host
			}
			"Section" {
				Write-Host
				Write-Host -ForegroundColor Cyan "`t`t`t$Header"
				Write-Host
			}
			"SubSection" {
				DrawLine
				Write-Host -ForegroundColor Green "`t$Header"
			}
		}
	}
	function WriteStat {
		param($Description, $Stat)
		Write-Host "$($Description): $Stat"
	}
	function WriteListStat {
		param($Description)
		BEGIN {
			Write-Host "$($Description):"
		}
		PROCESS {
			Write-Host "`t - $_"
		}
	}
	function DrawLine {
		param(
			$Length = 50
		)
		Write-Host (1..$Length | % { "-" } | Join-String)
	}
	filter FormatIPAddress {
		$_ | ? { $_ -ne $null } | % {
			$ip = $_
			try { $hostName = [System.Net.Dns]::Resolve($ip).HostName }
			catch { $hostName = $ip }
			
			if ($hostName -eq $ip) { return $ip }
			else { return "$ip ($hostName)" }
		}
	}

	function FilterNetworkFamily {
		[CmdletBinding()]
		param(
			[Parameter(ValueFromPipeline = $true)]$InputObject,
			$Property
		)

		PROCESS {
			$InputObject | % {
				$Address = $_
				if ($null -eq $Address) { return }

				if ($Property) {
					$ipEndPoint = $Property | % {
						$currentProperty = $Address
						$_.Split(".") | % { $currentProperty = Select-Object -ExpandProperty $_ -InputObject $currentProperty }
						return $currentProperty
					}
				} else {
					$ipEndPoint = $Address
				}
				switch ($Version) {
					"IPv4" { $validAddresssFamily = [System.Net.Sockets.AddressFamily]::InterNetwork }
					"IPv6" { $validAddresssFamily = [System.Net.Sockets.AddressFamily]::InterNetworkV6 }
				}
				$validIpEndPoint = $null
				$ipEndPoint | % {
					if ($null -eq $validIpEndPoint -and $_.AddressFamily -eq $validAddresssFamily) {
						$validIpEndPoint = $true
					}
					if ($_.AddressFamily -ne $validAddresssFamily) {
						$validIpEndPoint = $false
					}
				}
				
				if ($true -eq $validIpEndPoint) { return $_ }
			}
		}
	}

 	$globalIpProperties = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()	

 	WriteHeader "Interface Information for $($globalIpProperties.HostName).$($globalIpProperties.DomainName)" -Type Main

 	[System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() `
 	| ? {
 		$networkInterface = $_
		switch ($Version) {
			"IPv4" { return ($networkInterface.Supports([System.Net.NetworkInformation.NetworkInterfaceComponent]::IPv4)) }
			"IPv6" { return ($networkInterface.Supports([System.Net.NetworkInformation.NetworkInterfaceComponent]::IPv6)) }
		} 
	} `
	| ? { 
		($IncludeInactive -or ($_.OperationalStatus -eq [System.Net.NetworkInformation.OperationalStatus]::Up))
	} `
	| foreach {
		$ipProperties = $_.GetIPProperties()
		switch ($Version) {
			"IPv4" { $ipSpecificProperties = $ipProperties.GetIPv4Properties() }
			"IPv6" { $ipSpecificProperties = $ipProperties.GetIPv6Properties() }
		}

		WriteHeader $_.Name -Type Section

		WriteHeader "General"
 		WriteStat "Name" "$($_.Name) ($($_.NetworkInterfaceType))"
 		WriteStat "Type" $_.Description
 		WriteStat "Status" $_.OperationalStatus
		$macAddress = $_.GetPhysicalAddress().ToString() | % {
			$mac = $_
			if ([string]::IsNullOrWhiteSpace($mac)) { return "No MAC Address" }
			$split = 0..($mac.Length/2-1) | % { $mac.SubString(($_ * 2), 2) }
			[string]::Join("-", $split)
		} 
 		WriteStat "MAC Address" $macAddress
		WriteStat "MTU" $ipSpecificProperties.MTU
		if ($Version -eq "IPv4") { WriteStat "Forwarding (Routing) Packets" "$(?: { $ipSpecificProperties.IsForwardingEnabled } { "Enabled" } { "Disabled" })" }

		WriteHeader "Statistics"
		$ipStatistics = $_.GetIpStatistics()
		WriteStat "Speed" (Convert-DataSizeToHumanReadbleFormat $_.Speed -Type Bits -Precision 0 -Rate PerSecond)
		WriteStat "Bytes Received" (Convert-DataSizeToHumanReadbleFormat $ipStatistics.BytesReceived)
		WriteStat "Bytes Sent" (Convert-DataSizeToHumanReadbleFormat $ipStatistics.BytesSent)
		WriteStat "Output Queue Length" $ipStatistics.OutputQueueLength

		WriteHeader "DHCP Settings"
		if ($Version -eq "IPv4") { WriteStat "DHCP" "$(?: { $ipSpecificProperties.IsDhcpEnabled } { "Enabled" } { "Disabled" })" }
		WriteStat "DHCP Servers" ($ipProperties.DhcpServerAddresses | FilterNetworkFamily | % IPAddressToString | FormatIPAddress | Join-String -Separator ", ")

		WriteHeader "Gateway Settings"
		WriteStat "Gateway Servers" ($ipProperties.GatewayAddresses | FilterNetworkFamily -Property Address | % Address | % IPAddressToString | FormatIPAddress  | Join-String -Separator ", ")

		WriteHeader "DNS Settings"
		WriteStat "DNS Suffix" $ipProperties.DnsSuffix
		WriteStat "DNS Servers" ($ipProperties.DnsAddresses | FilterNetworkFamily | Select-Object -ExpandProperty IPAddressToString | FormatIPAddress  | Join-String -Separator ", ")
		if ($Version -eq "IPv4") {
			WriteStat "APIPA (Automatic Private Addressing / AutoNet)" "$(?: { $ipSpecificProperties.IsAutomaticPrivateAddressingEnabled } { "Enabled" } { "Disabled" }) & $(?: { $ipSpecificProperties.IsAutomaticPrivateAddressingActive } { "Active" } { "Inactive" })"
		}

		WriteHeader "WINS Settings"
		if (($Version -eq "IPv4" -and $ipSpecificProperties.UsesWins) -or ($null -ne ($ipProperties.WinsServersAddresses | ? { $null -ne $_ }))) {
			WriteStat "Status" "Enabled"
			WriteStat "WINS Servers" ($ipProperties.WinsServersAddresses | FilterNetworkFamily | % IPAddressToString | FormatIPAddress | Join-String -Separator ", " )
		} else {
			WriteStat "Status" "Disabled"
		}

		WriteHeader "Addresses"
		$ipProperties.AnycastAddresses | FilterNetworkFamily -Property Address | % Address | % IPAddressToString | FormatIPAddress | WriteListStat "Anycast Addresses"
	
		$ipProperties.MulticastAddresses | FilterNetworkFamily -Property Address | % Address | % IPAddressToString | FormatIPAddress | WriteListStat "Multicast Addresses"

		$ipProperties.UnicastAddresses | FilterNetworkFamily -Property Address | % {
			"$($_.Address.IPAddressToString | FormatIPAddress) $($_.IPv4Mask) ($($_.PrefixLength)) - Duplicate Address Detection: $($_.DuplicateAddressDetectionState)"
		} | WriteListStat "Unicast Addresses"
 	}
	
	WriteHeader "Connection Information" -Type Main

	WriteHeader "Active Connections" -Type Section
	WriteHeader "TCP Connections"
	$globalIpProperties.GetActiveTcpConnections() | FilterNetworkFamily -Property @("LocalEndPoint.Address", "RemoteEndPoint.Address") `
	 | Sort-Object -Property LocalEndPoint.Address, RemoteEndPoint.Address | Format-Table -Property LocalEndPoint, RemoteEndPoint, State

	WriteHeader "Active Listeners" -Type Section
	WriteHeader "TCP Listeners"
 	$globalIpProperties.GetActiveTcpListeners() | FilterNetworkFamily | `
 		Sort-Object -Property Port, Address | Format-Table -Property @(@{Name = "Port"; Width = 7; Alignment = "Left"; Expression = { $_.Port }}, @{Name = "Address"; Alignment = "Left"; Expression = { $_.Address }}) -AutoSize
 	WriteHeader "UDP Listeners"
 	$globalIpProperties.GetActiveUdpListeners() | FilterNetworkFamily | `
 		Sort-Object -Property Port, Address | Format-Table -Property @(@{Name = "Port"; Width = 7; Alignment = "Left"; Expression = { $_.Port }}, @{Name = "Address"; Alignment = "Left"; Expression = { $_.Address }}) -AutoSize

 		<#
http://technet.microsoft.com/library/hh849892.aspx

- Name (or Label) <string>
-- Expression <string> or <script block>
-- FormatString <string>
-- Width <int32>
-- Alignment (value can be "Left", "Center", or "Right")


 		#>
}