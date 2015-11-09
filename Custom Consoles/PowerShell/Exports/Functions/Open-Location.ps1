function Open-Location {
    [CmdletBinding()]
    param(
        [ValidateSet(
            "PowerShellProfile",
            
            "Home",
            "PowerShellUserFolder",
        	"UserFolder",

        	"PowerShellScripts",
            "UserScripts",
        	
            "PowerShellAppData",
            
            "InstallPath",
            "PowerShellConsoleModule",
            "ConsoleModule",
        	"PowerShellTemp",
        	"ConsoleGitHub",
            
        	"Documents",
        	"Desktop",

            "Computer",
            "NetworkConnections",
            
            "AppData",
            "LocalAppData",
            "ProgramData",
        	"SystemTemp",
            "PowerShellInstall",

            "CurrentDirectory",
            "Dir",
        	"Directory",
        	"Folder"
        )][Parameter(Position = 0)]$Location = "Folder",
        [Parameter(Position = 1, ValueFromRemainingArguments=$true)]$Path = $PWD.Path,
        [switch]$Shell,
        [ValidateSet("None", "Atom", "Code", "Default")]$Editor = "None"
    )

    DynamicParam
    {
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]

        $defaultParameter = New-Object System.Management.Automation.ParameterAttribute
        $defaultParameter.ParameterSetName = "__AllParameterSets"
        $attributeCollection.Add($defaultParameter)

        if ((Test-Path Variable:\Shell) -and $Shell) {
            $scriptBlockParameter = New-Object System.Management.Automation.RuntimeDefinedParameter('ScriptBlock', [System.Management.Automation.ScriptBlock], $attributeCollection)
            $paramDictionary.Add('ScriptBlock', $scriptBlockParameter)
        }

        return $paramDictionary
    }

    PROCESS {
        if (($PSCmdlet | % MyInvocation | % InvocationName) -eq "browse" -and -not $Shell) {
            $Shell = $true
        }
        
        $type = "Folder"
        $Path = switch ($Location)
        {
            "PowerShellProfile" { Split-Path $PROFILE.CurrentUserAllHosts -Parent }

            "Home" { $ProfileConfig.General.UserFolder }
            "PowerShellUserFolder" { $ProfileConfig.General.UserFolder }
            "UserFolder" { $ProfileConfig.General.UserFolder }

            "PowerShellScripts" { $ProfileConfig.General.UserScriptsFolder }
            "UserScripts" { $ProfileConfig.General.UserScriptsFolder }

            "PowerShellAppData" { $ProfileConfig.Module.AppSettingsFolder }

            "InstallPath" { $ProfileConfig.Module.InstallPath }
            "PowerShellConsoleModule" { $ProfileConfig.ConsolePaths.PowerShell }
            "ConsoleModule" { $ProfileConfig.ConsolePaths.PowerShell }
            "PowerShellTemp" { $ProfileConfig.General.TempFolder }
            "ConsoleGitHub" {
                $type = "URL"
                _workOnConsoleWorkingDirectory {
                     & git config --get remote.origin.url
                } -ReturnValue
            }
            
            "Documents" { [Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments) }
            "Desktop" {  [Environment]::GetFolderPath([Environment+SpecialFolder]::Desktop) }
            
            "Computer" { "::{20d04fe0-3aea-1069-a2d8-08002b30309d}" }
            "NetworkConnections" { "::{7007ACC7-3202-11D1-AAD2-00805FC1270E}" }
            
            "AppData" { $Env:APPDATA }
            "LocalAppData" { $Env:LOCALAPPDATA }
            "ProgamData" { $Env:ProgramData }
            "SystemTemp" { [System.IO.Path]::GetTempPath() }
            "PowerShellInstall" { [System.Diagnostics.Process]::GetCurrentProcess() | % Path | Split-Path -Parent }
            
            "CurrentDirectory" { $PWD.Path }
            "Dir" { $Path }
            "Directory" { $Path }
            "Folder" { $Path }
        }
        if ($type -eq "URL") { Open-UrlWithDefaultBrowser -Url $Path }
        elseif ($type -eq "Folder") {
            $Path = $Path.TrimEnd("\")
            if ($Shell) {
                if ($PSBoundParameters.ContainsKey("ScriptBlock")) {
                    Push-Location -Path $Path -StackName openLocation
                    try {
                        $PSBoundParameters.ScriptBlock.Invoke()
                    }
                    finally {
                        Pop-Location -StackName openLocation
                    }
                } else {
                    Set-Location -Path $Path
                }
            }
     		elseif ($Editor -ne "None") {
                Edit-CustomTextEditor -Path $Path -Editor $Editor
     		}
     		else {
     			& explorer $Path
     		}
    	}
    }
}
