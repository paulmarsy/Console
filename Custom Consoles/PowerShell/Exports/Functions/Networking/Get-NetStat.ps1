function Get-NetStat
{
    param(
        [Parameter(ParameterSetName="ProcessId",Mandatory=$true)]$ProcessId,
        [Parameter(ParameterSetName="OwnerProcess",Mandatory=$true)]$OwnerProcess,
        [Parameter(ParameterSetName="All",Mandatory=$true)][switch]$All,
        [switch]$ResolveAddresses
    )
    
    $DnsCache = @{
        "127.0.0.1" = $env:COMPUTERNAME
        "0.0.0.0" = $env:COMPUTERNAME
        "*" = $env:COMPUTERNAME
    }
    $ProcessCache = @{}
    
    & NETSTAT.EXE -aon | Select-Object -Skip 4 | % {
        $entry = ($_.Trim()) -split "\s+"
        $local = $entry[1] -split ":"
        $localAddress = [string]::Join(":", ($local | Select-Object -SkipLast 1))
        $remote = $entry[2] -split ":"
        $remoteAddress = [string]::Join(":", ($remote | Select-Object -SkipLast 1))
        if ($ResolveAddresses) {
            if (-not $DnsCache.Contains($localAddress)) {
                try {
                    $DnsCache[$localAddress] = [System.Net.DNS]::GetHostByAddress($localAddress).HostName
                }
                catch [System.Net.Sockets.SocketException] {
                    $DnsCache[$localAddress] = $localAddress
                }
            }
            $localAddress = $DnsCache[$localAddress]
            
            if (-not $DnsCache.Contains($remoteAddress)) {
                try {
                    $DnsCache[$remoteAddress] = [System.Net.DNS]::GetHostByAddress($remoteAddress).HostName
                }
                catch [System.Net.Sockets.SocketException] {
                    $DnsCache[$remoteAddress] = $remoteAddress
                }
            }
            $remoteAddress = $DnsCache[$remoteAddress]
        }
        if ($entry.Length -eq 5) {
            $state = $entry[3]
            $ownerPid = $entry[4]
        } else {
            $state = [string]::Empty
            $ownerPid = $entry[3]
        }
        
        if (-not $ProcessCache.Contains($ownerPid)) {
            $ProcessCache[$ownerPid] = Get-Process -Id $ownerPid | % Name
        }
        
        if (-not $All) {
            if ($null -ne $ProcessId -and $ownerPid -ne $ProcessId) { return }
            if ($null -ne $OwnerProcess -and $ProcessCache[$ownerPid] -ne $OwnerProcess) { return }
        }
        
		$outputObject = New-Object -TypeName PSObject -Property @{
			Protocol = $entry[0]
			LocalAddressIP = $LocalAddress
			LocalAddressPort = ($local | Select-Object -Last 1)
			ForeignAddressIP = $remoteAddress
			ForeignAddressPort = ($remote | Select-Object -Last 1)
			State = $state
            OwnerPid = $ownerPid
            OwnerProcess = $ProcessCache[$ownerPid]
		}
        
        $outputObject.PSTypeNames.Insert(0, 'Netstat')
        
        return $outputObject
	}
}