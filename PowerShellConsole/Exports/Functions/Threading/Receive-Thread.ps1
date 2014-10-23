function Receive-Thread {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]$State
    )

    $result = $State.Host.EndInvoke($State.AsyncWaitHandle)
    $State.Streams = $State.Host.Streams
    return $result
}