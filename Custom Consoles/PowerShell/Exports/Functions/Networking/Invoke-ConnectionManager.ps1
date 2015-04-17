function Invoke-ConnectionManager {
    [CmdletBinding(DefaultParameterSetName="Connect")]
    param(
        [Parameter(ParameterSetName="Reset")][switch]$Reset,
        [Parameter(ParameterSetName="List")][Alias("L")][switch]$List,

        [Parameter(ParameterSetName="Connect",Mandatory=$true,Position=0)][ValidateSet("NULL")]
        $NameToConnectTo = "NULL",

        [Parameter(ParameterSetName="AddDirectDefined",Mandatory=$true,Position=0)]
        [Parameter(ParameterSetName="AddTunnelDefined",Mandatory=$true,Position=0)]
        [Parameter(ParameterSetName="AddManualDefined",Mandatory=$true,Position=0)]
        $NameToAdd,

        [Parameter(ParameterSetName="AddDirectDefined",Mandatory=$true,Position=1)][switch]$AddDirectDefined,
        [Parameter(ParameterSetName="AddDirectDefined",Mandatory=$true)]$ComputerName,
        [Parameter(ParameterSetName="AddDirectDefined",Mandatory=$true)][ValidateSet("PowerShell", "RDC", "RDP", "SSH", "TELNET", "VNC", "UNDEFINED")]$InteractiveType = "UNDEFINED",
        [Parameter(ParameterSetName="AddDirectDefined")]$Port = $null,
        [Parameter(ParameterSetName="AddDirectDefined")]$Username = $null,
        [Parameter(ParameterSetName="AddDirectDefined")]$Password = $null,

        [Parameter(ParameterSetName="AddTunnelDefined",Mandatory=$true,Position=1)][switch]$AddTunnelDefined,
        [Parameter(ParameterSetName="AddTunnelDefined",Mandatory=$true)]$TunnelHost,
        [Parameter(ParameterSetName="AddTunnelDefined",Mandatory=$true)]$DestinationHost,
        [Parameter(ParameterSetName="AddTunnelDefined")][ValidateSet("RDC", "RDP", "SSH", "TELNET", "UNDEFINED")]$DestinationType = "UNDEFINED",
        [Parameter(ParameterSetName="AddTunnelDefined")]$DestinationPort = -1,
        [Parameter(ParameterSetName="AddTunnelDefined")][Parameter(ParameterSetName="Connect")][switch]$LeaveTunnelOpen,
        [Parameter(ParameterSetName="AddTunnelDefined")]$TunnelPort = $null,
        [Parameter(ParameterSetName="AddTunnelDefined")]$TunnelUsername = $null,
        [Parameter(ParameterSetName="AddTunnelDefined")]$TunnelPassword = $null,
        [Parameter(ParameterSetName="AddTunnelDefined")]$LocalPort = $null,
        [Parameter(ParameterSetName="AddTunnelDefined")]$DestinationUsername = $null,
        [Parameter(ParameterSetName="AddTunnelDefined")]$DestinationPassword = $null,

        [Parameter(ParameterSetName="AddManualDefined",Mandatory=$true,Position=1)][switch]$AddManualDefined,
        [Parameter(ParameterSetName="AddManualDefined",Mandatory=$true)]$ScriptBlock,

        [Parameter(ParameterSetName="AddDirectDefined")]
        [Parameter(ParameterSetName="AddTunnelDefined")]
        [Parameter(ParameterSetName="AddManualDefined")]
        [switch]$Quiet,

        [Parameter(ParameterSetName="AddDirectDefined")]
        [Parameter(ParameterSetName="AddTunnelDefined")]
        [Parameter(ParameterSetName="AddManualDefined")]
        [switch]$Force,

        [Parameter(ParameterSetName="Connect")][switch]$Connect
    )

    if ($Reset -and ($ProfileConfig.Temp.ContainsKey("ConnectionManager"))) {
        $ProfileConfig.Temp.Remove("ConnectionManager")
    }
    if (-not ($ProfileConfig.Temp.ContainsKey("ConnectionManager"))) {
        $ProfileConfig.Temp.ConnectionManager = @{NULL = {}}
    }

    if ($PsCmdlet.ParameterSetName -eq "List") {
        return ($ProfileConfig.Temp.ConnectionManager.Keys | ? { $_ -ne "NULL" })
    }

    if ($PsCmdlet.ParameterSetName.StartsWith("Add")) {
        if ($ProfileConfig.Temp.ConnectionManager.ContainsKey($NameToAdd) -and -not $Force) {
            Write-Error "ConnectionManager: Connection '$NameToAdd' already exists, to overwrite it use the -Force switch"
        } elseif ($ProfileConfig.Temp.ConnectionManager.ContainsKey($NameToAdd) -and $Force) {
            Write-Warning "ConnectionManager: Connection '$NameToAdd' already exists and will be replaced"
            $ProfileConfig.Temp.ConnectionManager.Remove($NameToAdd)
        }

        if ($PsCmdlet.ParameterSetName -eq "AddDirectDefined") {
            if ($InteractiveType -eq "UNDEFINED") {
                Write-Error "ConnectionManager: Managed tunnel connection requires either a DestinationType or a DestinationPort"
            } else {
                $ScriptBlock = {
                    Connect-Remote `
                    -ComputerName:$ComputerName `
                    -InteractiveType:$InteractiveType `
                    -Port:$Port `
                    -Username:$Username `
                    -Password:$Password
                }.GetNewClosure()
                if (-not $Quiet) { Write-Host -ForegroundColor DarkGreen "ConnectionManager: Storing Managed Direct Connection to $NameToAdd of type $InteractiveType" }
            }
        } elseif ($PsCmdlet.ParameterSetName -eq "AddTunnelDefined") {
            if ($DestinationPort -eq -1 -and $DestinationType -eq "UNDEFINED") {
                Write-Error "ConnectionManager: Managed tunnel connection requires either a DestinationType or a DestinationPort"
            }
            elseif ($DestinationPort -eq -1 -and $DestinationType -ne "UNDEFINED") {
                $ScriptBlock = {
                  param ([switch]$overrideLeaveTunnelOpen)
                  if ($LeaveTunnelOpen -or $overrideLeaveTunnelOpen) { $runtimeLeaveTunnelOpen = $true } else { $runtimeLeaveTunnelOpen = $false }
                  Connect-Tunnel `
                    -TunnelHost:$TunnelHost `
                    -DestinationHost:$DestinationHost `
                    -DestinationType:$DestinationType `
                    -LeaveTunnelOpen:$runtimeLeaveTunnelOpen `
                    -TunnelPort:$TunnelPort `
                    -TunnelUsername:$TunnelUsername `
                    -TunnelPassword:$TunnelPassword  `
                    -LocalPort:$LocalPort `
                    -DestinationUsername:$DestinationUsername `
                    -DestinationPassword:$DestinationPassword `
                }.GetNewClosure()
                if (-not $Quiet) { Write-Host -ForegroundColor DarkGreen "ConnectionManager: Storing Managed Tunneled Connection to $NameToAdd of type $DestinationType" }
            } elseif ($DestinationType -eq "UNDEFINED" -and $DestinationPort -ne -1) {
                 $ScriptBlock = {
                    param ([switch]$overrideLeaveTunnelOpen)
                    if ($LeaveTunnelOpen -or $overrideLeaveTunnelOpen) { $runtimeLeaveTunnelOpen = $true } else { $runtimeLeaveTunnelOpen = $false }
                    Connect-Tunnel `
                    -TunnelHost:$TunnelHost `
                    -DestinationHost:$DestinationHost `
                    -DestinationPort:$DestinationPort `
                    -LeaveTunnelOpen:$runtimeLeaveTunnelOpen `
                    -TunnelPort:$TunnelPort `
                    -TunnelUsername:$TunnelUsername `
                    -TunnelPassword:$TunnelPassword  `
                    -LocalPort:$LocalPort `
                    -DestinationUsername:$DestinationUsername `
                    -DestinationPassword:$DestinationPassword
                }.GetNewClosure()
                if (-not $Quiet) { Write-Host -ForegroundColor DarkGreen "ConnectionManager: Storing Managed Tunneled Connection to $NameToAdd for $($DestinationHost):$($DestinationPort)" }
            }
        } elseif ($PsCmdlet.ParameterSetName -eq "AddManualDefined") {
            if (-not $Quiet) { Write-Host -ForegroundColor DarkGreen "ConnectionManager: Storing Manual Connection to $NameToAdd" }
        }
        $ProfileConfig.Temp.ConnectionManager.Add($NameToAdd, @{ ScriptBlock = $ScriptBlock; Type = $PsCmdlet.ParameterSetName })

        $ValidValuesField = [System.Management.Automation.ValidateSetAttribute].GetField("validValues", [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Instance)
        $MyInvocation.MyCommand.Parameters["NameToConnectTo"].Attributes | ? { $_ -is [System.Management.Automation.ValidateSetAttribute] } | % {
            $ValidValuesField.SetValue($_, ([string[]]$ProfileConfig.Temp.ConnectionManager.Keys))
        }
    } elseif ($PsCmdlet.ParameterSetName -eq "Connect") {
        if (-not $ProfileConfig.Temp.ConnectionManager.ContainsKey($NameToConnectTo)) {
            throw "ConnectionManager: Unable to find connection '$NameToConnectTo', have you added it yet?"
        } elseif ($NameToConnectTo -eq "NULL") {
            throw "ConnectionManager: Can't connect to NULL, have you added any connections yet?"
        }

        $ScriptBlock = $ProfileConfig.Temp.ConnectionManager[$NameToConnectTo].ScriptBlock
        if ($ProfileConfig.Temp.ConnectionManager[$NameToConnectTo].Type -eq "AddTunnelDefined") { Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList @($LeaveTunnelOpen) }
        else { Invoke-Command -ScriptBlock $ScriptBlock }
    }
}
