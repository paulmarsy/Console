function Get-ProcessParent {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName="PID", ValueFromPipeline=$true, Mandatory=$true)]$Id,
        [Parameter(ParameterSetName="Process", ValueFromPipeline=$true, Mandatory=$true)]$Process,
        [Parameter(ParameterSetName="Name", ValueFromPipeline=$true, Mandatory=$true)]$Name
    )
    
    PROCESS  {
        switch ($PsCmdlet.ParameterSetName) {
            "PID" { $childPid = $Id }
            "Process" { $childPid = $Process.Id }
            "Name" { $childPid = Get-Process -Name $Name -ErrorAction Ignore | Select-Object -ExpandProperty Id }
        }
        if ($null -eq $childPid) {
            throw "Unable to find process $_"
        }
        
        $parentProcessId = Get-CimInstance -ClassName Win32_Process -Property ParentProcessId -KeyOnly -Filter ("ProcessId = '{0}'" -f $childPid) | Select-Object -ExpandProperty ParentProcessId
        if ($null -eq $parentProcessId) {
            throw "$_ does not have a parent process id (has it exited?)"
        }
        
        switch ($PsCmdlet.ParameterSetName) {
            "PID" { Write-Output $parentProcessId }
            "Process" { Get-Process -Id $parentProcessId | Write-Output }
            "Name" { Get-Process -Id $parentProcessId | Select-Object -ExpandProperty Name }
        }
    }
}