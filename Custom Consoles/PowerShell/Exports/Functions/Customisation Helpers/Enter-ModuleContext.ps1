function Enter-ModuleContext {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [scriptblock]
        $ScriptBlock,
        
        [switch]
        $Invoke
    )
    
    $flags = [System.Reflection.BindingFlags]'Instance,NonPublic'
    
    $SessionStateInternal = $ExecutionContext.SessionState.GetType().GetProperty('Internal', $flags).GetValue($ExecutionContext.SessionState, $null)

    [scriptblock].GetProperty('SessionStateInternal', $flags).SetValue($ScriptBlock, $SessionStateInternal, $null)
    
    if ($Invoke) { 
        $ScriptBlock.Invoke() | Write-Output
    } else {
        Write-Output $ScriptBlock
    }
}