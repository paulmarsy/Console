function Get-OnlineHelp {
    param(
        [Alias("Name")][Parameter(ValueFromPipeline = $true)][ValidateNotNullOrEmpty()]$InputObject
    )

    PROCESS {
        $InputObject | % { 
            Get-Help -Name $_ -Online
        } 
    }
}