function Get-NetStat
{
    param(
        [switch]$ResolveAddresses
    )
    & NETSTAT.EXE -ao (?: { $ResolveAddresses } { "-f" } { "-n" })| Select-Object -Skip 4 | % {
        $entry = ($_.Trim()) -split "\s+"
        $local = $entry[1] -split ":"
        $remote = $entry[2] -split ":"
        if ($entry.Length -eq 5) {
            $state = $entry[3]
            $ownerPid = $entry[4]
        } else {
            $state = [string]::Empty
            $ownerPid = $entry[3]
        }
        
		$outputObject = New-Object -TypeName PSObject -Property @{
			Protocol = $entry[0]
			LocalAddressIP = ([string]::Join(":", ($local | Select-Object -SkipLast 1)))
			LocalAddressPort = ($local | Select-Object -Last 1)
			ForeignAddressIP = ([string]::Join(":", ($remote | Select-Object -SkipLast 1)))
			ForeignAddressPort = ($remote | Select-Object -Last 1)
			State = $state
            OwnerPid = $ownerPid
            OwnerProcess = (Get-Process -Id $ownerPid | % Name)
		}
        
        $outputObject.PSTypeNames.Insert(0, 'Netstat')
        
        return $outputObject
	}
}