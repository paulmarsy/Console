function Start-Thread {
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory=$true,Position=0)][ScriptBlock]$ScriptBlock,
        $ArgumentList
    )

    $powerShellHost = [PowerShell]::Create()
    $script = $powerShellHost.AddScript($ScriptBlock)

    if ($null -ne $ScriptBlock.Ast.ParamBlock -and $null -ne $ArgumentList) {
        $i = -1
        $ScriptBlock.Ast.ParamBlock.Parameters.Name.VariablePath | ? { $null -ne $_ -and $null -ne $ArgumentList[$i]} | % {    
            $i++
            $script.AddParameter(($_.ToString()), $ArgumentList[$i]) | Out-Null
        }
    }
    $ArgumentList | % { $script.AddArgument($_) } | Out-Null
    
    $asyncWaitHandle = $powerShellHost.BeginInvoke()
    
    return (New-Object -TypeName psobject -Property @{
        Id = $powerShellHost.InstanceId
        Commands = $powerShellHost.Commands
        Streams = $powerShellHost.Streams
        Host = $powerShellHost
        AsyncWaitHandle = $asyncWaitHandle
    })
}