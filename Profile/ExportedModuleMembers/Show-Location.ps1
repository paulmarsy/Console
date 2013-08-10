param($InstallPath)

Set-Alias browse Show-Location
function Show-Location {
    [CmdletBinding()]
	param(
		[ValidateSet("CurrentDirectory", "InstallPath", "Documents", "Profile")]
        $location = "CurrentDirectory"
    )
    
	$path = switch ($location)
    {
        "CurrentDirectory" { "." }
        "InstallPath" { "$InstallPath" }
        "Documents" { "/n" }
        "Profile" { Split-Path $PROFILE.CurrentUserAllHosts -Parent }
    }
	& explorer $path
}