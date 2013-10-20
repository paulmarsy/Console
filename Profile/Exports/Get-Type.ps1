filter Get-Type {
    $_ | ? { $null -ne $_ } | % { $_.GetType() }
}
@{Function = "Get-Type"}