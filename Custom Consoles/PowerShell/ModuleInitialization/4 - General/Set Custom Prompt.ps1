param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $false}) }

if ($ProfileConfig.General.IsAdmin) { $promptSecurityContext = "Red" }
else { $promptSecurityContext = "Green" }

if (Test-Path -Path Function:Global:prompt) {
    Remove-Item -Path Function:Global:prompt -Force
}

New-Item -Path Function:Global:prompt -Force -Value ([ScriptBlock]::Create({
    [CmdletBinding()]
    param ()
    
    if ($PSCmdlet.GetVariableValue("PSDebugContext")) {
        Write-Host -ForegroundColor $promptSecurityContext -NoNewLine "[DBG] "
    }

    if ($PWD.Provider.Name -eq 'FileSystem') {
        if ([System.IO.Path]::GetDirectoryName($PWD.ProviderPath)) {
            Write-Host -ForegroundColor $promptSecurityContext -NoNewLine ((Get-ChildItem -Path ([System.IO.Path]::GetDirectoryName($PWD.ProviderPath)) -Name ([System.IO.Path]::GetFileName($PWD.ProviderPath)) -Force).PSChildName)
        } else {
            Write-Host -ForegroundColor $promptSecurityContext -NoNewLine ([System.IO.Path]::GetPathRoot($PWD.ProviderPath))
        }
        if (Test-Path Function:\Write-VcsStatus) { Write-VcsStatus }
    } else {
        Write-Host -ForegroundColor $promptSecurityContext -NoNewLine $PWD.ProviderPath
    }

    if ($NestedPromptLevel -ne 0) {
        Write-Host -ForegroundColor $promptSecurityContext -NoNewLine " ($NestedPromptLevel)"
    }

    return "$ "
}).GetNewClosure())