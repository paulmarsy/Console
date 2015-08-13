function Wait-Thread {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]$State,
        [int]$MillisecondInterval = 50,
        [int]$Timeout = -1
    )

    PROCESS {
        if ($Timeout -le -1) {
            $maxDateTime = [datetime]::MaxValue
        } else {
            $maxDateTime = Get-Date | % AddSeconds $Timeout
        }
        
        while ($State.Host.InvocationStateInfo.State -in @(
            ([System.Management.Automation.PSInvocationState]::NotStarted)
            ([System.Management.Automation.PSInvocationState]::Running)
            ([System.Management.Automation.PSInvocationState]::Stopping)
        ) -or (Get-Date) -ge $maxDateTime) {
            Start-Sleep -Milliseconds $MillisecondInterval
        }
        
        $State
    }
}