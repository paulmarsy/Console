function Open-Location {
    [CmdletBinding()]
    param(
        [ValidateSet(
        	"InstallPath",

            "PowerShellProfile",

            "PowerShellConsoleModule",
            "ConsoleModule",
        	"ConsoleGitHub",

            "CurrentDirectory",

            "Dir",
        	"Directory",
        	"Folder",

            "Home",
        	"PowerShellUserFolder",
        	"UserFolder",

        	"PowerShellScripts",
            "UserScripts",

            "PowerShellAppData",

        	"PowerShellTemp",

        	"SystemTemp",
        	"Documents",
        	"Desktop",
        	"Computer",
            "AppData",
            "LocalAppData",
            "ProgramData",
            "PowerShellInstall"
        )][Parameter(Position = 0)]$Location = "Folder",
        [Parameter(Position = 1, ValueFromRemainingArguments=$true)]$Path = $PWD.Path,
        [switch]$Shell,
        [switch]$AtomEditor
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
        $type = "Folder"
        $Path = switch ($Location)
        {
            "InstallPath" { $ProfileConfig.Module.InstallPath }

            "PowerShellProfile" { Split-Path $PROFILE.CurrentUserAllHosts -Parent }

            "PowerShellConsoleModule" { $ProfileConfig.ConsolePaths.PowerShell }
            "ConsoleModule" { $ProfileConfig.ConsolePaths.PowerShell }
            "ConsoleGitHub" {
                $type = "URL"
                _workOnConsoleWorkingDirectory {
                     & git config --get remote.origin.url
                } -ReturnValue
            }

            "CurrentDirectory" { $PWD.Path }

            "Dir" { $Path }
            "Directory" { $Path }
            "Folder" { $Path }

            "Home" { $ProfileConfig.General.UserFolder }
            "PowerShellUserFolder" { $ProfileConfig.General.UserFolder }
            "UserFolder" { $ProfileConfig.General.UserFolder }

            "PowerShellScripts" { $ProfileConfig.General.UserScriptsFolder }
            "UserScripts" { $ProfileConfig.General.UserScriptsFolder }

            "PowerShellAppData" { $ProfileConfig.Module.AppSettingsFolder }

            "PowerShellTemp" { $ProfileConfig.General.TempFolder }

            "SystemTemp" { [System.IO.Path]::GetTempPath() }
            "Documents" { [Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments) }
            "Desktop" {  [Environment]::GetFolderPath([Environment+SpecialFolder]::Desktop) }
            "Computer" { "::{20d04fe0-3aea-1069-a2d8-08002b30309d}" }
            "AppData" { $Env:APPDATA }
            "LocalAppData" { $Env:LOCALAPPDATA }
            "ProgamData" { $Env:ProgramData }
            "PowerShellInstall" { [System.Diagnostics.Process]::GetCurrentProcess() | % Path | Split-Path -Parent }
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
     		elseif ($AtomEditor) {
                Edit-InAtom $Path
     		}
     		else {
     			& explorer $Path
     		}
    	}
    }
}
