function Receive-Thread {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]$State
    )

    $State.Host.EndInvoke($State.AsyncWaitHandle)
}