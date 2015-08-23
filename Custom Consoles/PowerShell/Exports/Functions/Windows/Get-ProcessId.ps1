filter Get-ProcessId {
    param($ProcessName)
    
    Get-Process -Name $ProcessName | % Id
}