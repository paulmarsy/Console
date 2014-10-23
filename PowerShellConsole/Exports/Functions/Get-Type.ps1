filter Get-Type {
    $_ | ? { $null -ne $_ } | % GetType
}