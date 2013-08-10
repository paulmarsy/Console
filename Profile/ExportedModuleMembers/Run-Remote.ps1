param($InstallPath)

Set-Alias remote Run-Remote
function Run-Remote {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        $ComputerName,
        [ValidateSet("PowerShell", "RDC")][Parameter(ParameterSetName="Interactive")]
        $Location = "PowerShell",
        [Parameter(ValueFromRemainingArguments=$true,ParameterSetName="Command")]
        $Command
    )

    if ($command) { 
        $psexecOutput = [IO.Path]::GetTempFileName()
        Write-Verbose "PsExec Output: $psexecOutput"

        $existingCommand = Invoke-Command -ComputerName $ComputerName { Get-Command -Name $command[0] -CommandType Application }

        if ($null -ne $existingCommand) {
            & PsExec.exe -acceptEula \\$ComputerName $command 2>$psexecOutput
        }
        else {
            & PsExec.exe -acceptEula \\$ComputerName -c $command 2>$psexecOutput
        }

        Get-Content $psexecOutput | Select-Object -Last 3 | Select-Object -First 2
        if (-not $PSBoundParameters['Verbose']) {
            Remove-Item $psexecOutput -Force
        }
    }
    elseif ($location -eq "PowerShell") {
        Enter-PSSession -ComputerName $ComputerName
    }
    elseif ($location -eq "RDC"){
        & mstsc /v:$ComputerName /edit (Join-Path $InstallPath "Support Files\Default.rdp")
    }
}