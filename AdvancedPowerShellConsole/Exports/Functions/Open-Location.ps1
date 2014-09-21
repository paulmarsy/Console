function Open-Location {
    [CmdletBinding()]
    param(
        [ValidateSet("InstallPath", "Profile", "AdvancedPowerShellConsoleModule", "CurrentDirectory", "Directory", "Folder", "PowerShellScripts", "Scripts", "Documents", "Desktop", "Computer", "ConsoleGitHub")]
        [Parameter(Position = 1)]$location = "CurrentDirectory",
        [Parameter(Position = 2)]$path = $pwd,
        [Parameter(ParameterSetName = "Shell")][switch]$shell,
        [Parameter(ParameterSetName = "Shell")]$scriptBlock
    )
    
    $type = "Folder"
    $path = switch ($location)
    {
        "InstallPath" { $ProfileConfig.General.InstallPath }
        "Profile" { Split-Path $PROFILE }
        "AdvancedPowerShellConsoleModule" { Get-Module AdvancedPowerShellConsole | select -ExpandProperty ModuleBase }
        "CurrentDirectory" { $pwd }
        "Directory" { $path }
        "Folder" { $path }
        "PowerShellScripts" { $ProfileConfig.General.PowerShellScriptsFolder }
        "Scripts" { $ProfileConfig.General.PowerShellScriptsFolder }
        "Documents" { [Environment]::GetFolderPath( [Environment+SpecialFolder]::MyDocuments) }
        "Desktop" {  [Environment]::GetFolderPath([Environment+SpecialFolder]::Desktop) }
        "Computer" { "::{20d04fe0-3aea-1069-a2d8-08002b30309d}" }
        "ConsoleGitHub" {
        	$type = "URL"
        	Push-Location $ProfileConfig.General.InstallPath
			try { $gitHubUrl = & git config --get remote.origin.url }
			finally { Pop-Location }
			$gitHubUrl
		}
    }
    if ($type -eq "URL") { Open-UrlWithDefaultBrowser -Url $path }
    elseif ($type -eq "Folder") {
	    if (-not $shell) { & explorer $path }
	    else {
	    	Push-Location $path -StackName openLocation
	    	if ($scriptBlock) {
                try {
				    & $scriptBlock
                }
                finally {
    				Pop-Location -StackName openLocation
                }
	    	}
 		}
	}
}