function UnLock-Time {
    Write-Host "Unlocking session time... " -NoNewLine
    [System.Environment]::SetEnvironmentVariable("ConEmuFakeDT", $null, [System.EnvironmentVariableTarget]::Process)
    Write-Host "Done"    
}