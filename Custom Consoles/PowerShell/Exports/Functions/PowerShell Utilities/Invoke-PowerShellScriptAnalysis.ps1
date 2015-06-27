function Invoke-PowerShellScriptAnalysis {
    param(
        [Parameter(ParameterSetName="Path")][ValidateScript({Test-Path -Path $_})]$Path = $PWD.Path,
        
        [Parameter(ParameterSetName="PowerShellConsole")][switch]$TestPowerShellConsole,
        
        $ExcludeRule = @(
                         'PSAvoidUsingPositionalParameters',
                         'PSAvoidUsingWriteHost',
                         'PSAvoidUsingCmdletAliases',
                         'PSAvoidUninitializedVariable',
                         'PSAvoidUsingPlainTextForPassword',
                         'PSAvoidUsingInternalURLs',
                         'PSAvoidUsingUserNameAndPassWordParams',
                         'PSAvoidGlobalVars',
                         'PSUseSingularNouns',
                         'PSProvideDefaultParameterValue'
                         'PSUseShouldProcessForStateChangingFunctions'
                         'PSProvideCommentHelp'
                         'PSUseShouldProcessForStateChangingFunctions'
                        ),
        [switch]$DontInstallOrUdpdate
    )
    
    if ($TestPowerShellConsole) {
        $Path = Join-Path $ProfileConfig.Module.InstallPath "Custom Consoles\PowerShell"
    }
    
    if (-not $DontInstallOrUdpdate) {
        if (Get-InstalledModule | ? Name -EQ PSScriptAnalyzer) {
            Update-Module -Name PSScriptAnalyzer
        } else {
            Install-Module -Name PSScriptAnalyzer -Scope CurrentUser
        }
    }
    
    Import-Module -Name PSScriptAnalyzer -Force
    Invoke-ScriptAnalyzer -Path $Path -Recurse -ExcludeRule $ExcludeRule
}