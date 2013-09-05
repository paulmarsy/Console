function Enable-Debug {
    [CmdletBinding()]

    $Global:DebugPreference = "Continue"
    $Global:VerbosePreference = "Continue"
}