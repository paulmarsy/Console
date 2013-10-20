function Disable-Debug {
    [CmdletBinding()]

    $Global:DebugPreference = "SilentlyContinue"
    $Global:VerbosePreference = "SilentlyContinue"
}
@{Function = "Disable-Debug"}