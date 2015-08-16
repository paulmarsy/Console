function Lock-Time {
    param(
        [datetime]$DateTime = (Get-Date)
    )
    
    Write-Host ("Locking session time to {0}... " -f $DateTime) -NoNewLine
    [System.Environment]::SetEnvironmentVariable("ConEmuFakeDT", $DateTime.ToString("s"), [System.EnvironmentVariableTarget]::Process)
    Write-Host "Done"    
}