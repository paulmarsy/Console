function _Remove-ExistingUserScripts {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')]
    param()
    
    if ($ProfileConfig.Temp.ContainsKey("UserScriptExports")) {
        $ProfileConfig.Temp.UserScriptExports.Functions | Is -Not Null | % {
            Write-Warning "Removing previously imported user function $_"
            Remove-Item -Path "Function:$_" -Force
        }
        $ProfileConfig.Temp.UserScriptExports.Aliases | Is -Not Null | % {
            Write-Warning "Removing previously imported user alias $_"
            Remove-Item -Path "Alias:$_" -Force
        }
        $ProfileConfig.Temp.Remove("UserScriptExports")
        Write-Host
    }
}