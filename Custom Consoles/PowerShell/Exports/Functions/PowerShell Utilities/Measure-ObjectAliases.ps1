function Measure-ObjectAliases {
    param(
        [Parameter(ValueFromPipeline=$true)][psobject]$InputObject,
        [string[]]$Property
    )
    
    BEGIN
    {
        $measureObject = $ExecutionContext.InvokeCommand.GetCommand('Measure-Object', [System.Management.Automation.CommandTypes]::Cmdlet) 
        $measureObjectCommand = switch ($PSCmdlet | % MyInvocation | % InvocationName) {
            "Average" { { & $measureObject -Average } }
            "Lines" { { & $measureObject -Lines } }
            "Maximum" { { & $measureObject -Maximum } }
            "Minimum" { { & $measureObject -Minimum } }
            "Sum" { { & $measureObject -Sum } }
            default { { & $measureObject } }
        }
        $steppablePipeline = $measureObjectCommand.GetSteppablePipeline($MyInvocation.CommandOrigin) 
        $steppablePipeline.Begin($PSCmdlet) 
    }

    PROCESS
    {
         $steppablePipeline.Process($_)
    }
    
    END
    {
        $steppablePipeline.End()
    }
}