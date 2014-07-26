function Disable-Debug {
    $Global:DebugPreference = "SilentlyContinue"
    $Global:VerbosePreference = "SilentlyContinue"
}