filter Get-ProcessId {
    param($ProcessName)
    
    $baseProcessName = [System.IO.Path]::GetFileNameWithoutExtension($ProcessName)
    
    Get-Processs | ? ProcessName -eq $ProcessName | % Id
}