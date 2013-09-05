Set-Alias browse Show-Location
function Show-Location {
    [CmdletBinding()]
	param(
		[ValidateSet("InstallPath", "Profile", "CurrentDirectory", "Documents", "Computer")]
        $location = "CurrentDirectory"
    )
    
	$path = switch ($location)
    {
        "InstallPath" { "$InstallPath" }
        "Profile" { Split-Path $PROFILE }
        "CurrentDirectory" { $pwd }
        "Documents" { "::{450d8fba-ad25-11d0-98a8-0800361b1103}" }
        "Computer" { "::{20d04fe0-3aea-1069-a2d8-08002b30309d}" }
    }
	& explorer $path
}