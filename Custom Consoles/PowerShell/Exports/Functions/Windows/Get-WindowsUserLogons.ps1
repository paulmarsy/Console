function Get-WindowsUserLogons {
    param(
        $ComputerName = $env:COMPUTERNAME,
        [switch]$IncludeMachineLogons,
        [switch]$ExcludeSystemLogons,
        [switch]$ExcludeServerAppLogons,
        [switch]$ExcludeMyLogons,
        [switch]$ExcludeAnonymousLogons,
        [string[]]$Exclude = @()
    )
    
    function Get-LogonTypeName { 
        param($LogonType) 
        
        switch ($LogonType) { 
            0 {"System"} 
            2 {"Interactive"} 
            3 {"Network"} 
            4 {"Batch"} 
            5 {"Service"} 
            6 {"Proxy"} 
            7 {"Unlock"} 
            8 {"NetworkCleartext"} 
            9 {"NewCredentials"} 
            10 {"RemoteInteractive"} 
            11 {"CachedInteractive"} 
            12 {"CachedRemoteInteractive"} 
            13 {"CachedUnlock"} 
            default {"Unknown"} 
        } 
    } 
    
    Get-Eventlog -LogName Security -ComputerName $ComputerName | % {
        $date = $_.TimeGenerated
        if ($_.EventID -eq 4624) {
            $logonType = Get-LogonTypeName $_.ReplacementStrings[8]
            $successful = $true
            $user = $_.ReplacementStrings[5]
        }
        elseif ($_.EventID -eq 4625) {
            $logonType = Get-LogonTypeName $_.ReplacementStrings[10]
            $successful = $false
            $user = $_.ReplacementStrings[5]
        }
        elseif ($_.EventID -eq 4647) {
            $logonType = "Logoff"
            $successful = $true
            $user = $_.ReplacementStrings[1]
        }
        else {
            return
        }
        if ($User -in $Exclude) { return }
        if (!$IncludeMachineLogons -and $User -like '*$') { return }
        if ($ExcludeSystemLogons -and ($User -in @(
            'SYSTEM'
            'LOCAL SERVICE'
            'NETWORK SERVICE'
            'IUSR'
            ) -or $User -like 'DWM-?')) { return }
        if ($ExcludeServerAppLogons -and ($User -in @(
            "IUSR"
            ) -or $User -like 'MsDtsServer???')) { return }
        if ($ExcludeMyLogons -and $User -eq $env:USERNAME) { return }
        if ($ExcludeAnonymousLogons -and $User -eq 'ANONYMOUS LOGON') { return }
        
        $outputObject = New-Object -TypeName PSObject -Property @{
            Date = $date
            LogonType = $logonType
            Successful = $successful
            User = $user
        }
        $outputObject.PSTypeNames.Insert(0, 'WindowsLogon')
        
        return $outputObject
    }
}