function Test-NetworkStatus
{
    $numberOfConnectedNetworks = Get-NetAdapter -Physical | ? { $_.Status -eq "Up" } | Measure-Object -Line | Select-Object -ExpandProperty Lines

    return ($numberOfConnectedNetworks -ge 1)
}