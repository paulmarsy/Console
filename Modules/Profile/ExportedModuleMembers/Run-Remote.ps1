Set-Alias remote Run-Remote
function Run-Remote {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $ComputerName,
        [Parameter(ValueFromRemainingArguments=$true)]
        $command
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
    else {
        Enter-PSSession -ComputerName $ComputerName
    }
}