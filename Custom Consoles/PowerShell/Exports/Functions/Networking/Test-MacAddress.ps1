function Test-MacAddress {
    param(
        [Parameter(Mandatory=$true)]$MacAddress,
        [ValidateSet(":", "-", ":-")]$Seperator = ":-"
    )
    
    $MacAddress -match "^([0-9A-F]{2}[$Seperator]){5}([0-9A-F]{2})$"
}