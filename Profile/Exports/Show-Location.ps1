Set-Alias browse Show-Location
function Show-Location {
    [CmdletBinding()]
    param(
        [ValidateSet("InstallPath", "ProfileModule", "Profile", "CurrentDirectory", "PowerShellScripts", "Scripts", "Documents", "Computer", "GitHub")]
        [Parameter(Position = 1)]$location = "CurrentDirectory",
        [Parameter(ParameterSetName = "Shell")][switch]$shell,
        [Parameter(ParameterSetName = "Shell")]$scriptBlock
    )
    
    $path = switch ($location)
    {
        "InstallPath" { $ProfileConfig.General.InstallPath }
        "Profile" { Split-Path $PROFILE }
        "ProfileModule" { Get-Module Profile | select -ExpandProperty ModuleBase }
        "CurrentDirectory" { $pwd }
        "PowerShellScripts" { $ProfileConfig.General.PowerShellScriptsFolder }
        "Scripts" { $ProfileConfig.General.PowerShellScriptsFolder }
        "Documents" { "::{450d8fba-ad25-11d0-98a8-0800361b1103}" }
        "Computer" { "::{20d04fe0-3aea-1069-a2d8-08002b30309d}" }
        "GitHub" { & git config --get remote.origin.url }
    }
    if (-not $shell) { & explorer $path }
    else {
    	Push-Location $path
    	if ($scriptBlock) {
			& $scriptBlock
			Pop-Location
    	}
 }
}
@{Function = "Show-Location"; Alias = "browse"}