function Get-ProcessResources {
    param(
        [Parameter(ParameterSetName="ProcessId",Mandatory=$true)]$ProcessId,
        [Parameter(ParameterSetName="ImageName",Mandatory=$true)]$ImageName,
        [Parameter(ParameterSetName="Username",Mandatory=$true)]$Username
    )
    
    $filter = [string]::Empty
    if ($ProcessId) {
        $filter = "PID eq $ProcessId"
    } elseif ($ImageName) {
        $filter = "IMAGENAME eq $ImageName"
    } elseif ($Username) {
        $filter = "USERNAME eq $Username"
    }
    
    & tasklist.exe /NH /SVC /FI $filter | Select-Object -Skip 1 | % {
        $id = Split-String -Input $_ -RemoveEmptyStrings | Select-Object -Skip 1 -First 1

		$outputObject = New-Object -TypeName PSObject -Property @{
			PID = $id
            ImageName = (Split-String -Input $_ -RemoveEmptyStrings | Select-Object -First 1)
            Services = (Split-String -Input $_ -RemoveEmptyStrings | Select-Object -Skip 2)
            NetworkConnections = (Get-NetStat -ProcessId $id)
            Handles = (& handle.exe -p $id  | Select-Object -Skip 5 | % {
                $handleDetails = Split-String -Input $_ -RemoveEmptyStrings 
                return (@{
                    Id = ($handleDetails[0].TrimEnd(':'))
                    Type = $handleDetails[1]
                    Resource = $handleDetails[2]
                    })
            })
            Modules = (& Listdlls.exe $id | Select-Object -Skip 10 | % { Split-String -Input $_ -RemoveEmptyStrings | Select-Object -Skip 2 })
		}
        
        $outputObject.PSTypeNames.Insert(0, 'ProcessResources')
        
        return $outputObject
    }    
}