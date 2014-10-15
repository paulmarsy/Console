function Open-Location {
    [CmdletBinding()]
    param(
        [ValidateSet(
        	"InstallPath",
        	"Profile",
        	"AdvancedPowerShellConsoleModule",
        	"CurrentDirectory",
        	"Directory",
        	"Folder",
        	"PowerShellUserFolder",
        	"UserFolder",
        	"PowerShellScripts",
        	"Scripts",
        	"PowerShellTemp",
        	"Temp",
        	"Documents",
        	"Desktop",
        	"Computer",
        	"ConsoleGitHub"
        )][Parameter(Position = 0)]$Location = "CurrentDirectory",
        [Parameter(Position = 1)]$Path = $pwd,
        [Parameter(ParameterSetName = "Shell")][switch]$Shell,
        [Parameter(ParameterSetName = "Shell")]$ScriptBlock
    )
    
    $type = "Folder"
    $Path = switch ($Location)
    {
        "InstallPath" { $ProfileConfig.General.InstallPath }
        "Profile" { Split-Path $PROFILE }
        "AdvancedPowerShellConsoleModule" { Get-Module AdvancedPowerShellConsole | select -ExpandProperty ModuleBase }
        "CurrentDirectory" { $pwd }
        "Directory" { $Path }
        "Folder" { $Path }
        "PowerShellUserFolder" { $ProfileConfig.General.PowerShellUserFolder }
        "UserFolder" { $ProfileConfig.General.PowerShellUserFolder }
        "PowerShellScripts" { $ProfileConfig.General.PowerShellUserScriptsFolder }
        "Scripts" { $ProfileConfig.General.PowerShellUserScriptsFolder }
        "PowerShellTemp" { $ProfileConfig.General.PowerShellTempFolder }
        "Temp" { $ProfileConfig.General.PowerShellTempFolder }
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
    if ($type -eq "URL") { Open-UrlWithDefaultBrowser -Url $Path }
    elseif ($type -eq "Folder") {
	    if (-not $Shell) { & explorer $Path }
	    else {
	    	Push-Location $Path -StackName openLocation
	    	if ($ScriptBlock) {
                try {
				    & $ScriptBlock
                }
                finally {
    				Pop-Location -StackName openLocation
                }
	    	}
 		}
	}
}