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
    
    $originalLASTEXITCODE = $Global:LASTEXITCODE
    try {
        if ($PSCmdlet.GetVariableValue("PSDebugContext")) {
           Write-Host -ForegroundColor $promptSecurityContext -NoNewLine "[DBG] "
        }

        $currentPath = $PWD.Path
        $parentPath = Split-Path -Path $currentPath -Parent
        if ([string]::IsNullOrWhiteSpace($parentPath)) {
            $path = $PWD.Drive
        }  else {
            $currentBaseName = Split-Path $currentPath -Leaf
            $path = Get-ChildItem -Path $parentPath -Force -ErrorAction Ignore | ? PSChildName -eq $currentBaseName | Select-Object -ExpandProperty PSChildName -First 1
        }
        
        if ([string]::IsNullOrWhiteSpace($path)) {
            Write-Host -ForegroundColor $promptSecurityContext -NoNewLine "<Invalid Path>"
        } else {
            Write-Host -ForegroundColor $promptSecurityContext -NoNewLine $path
            if (Test-Path Function:\Write-VcsStatus) { Write-VcsStatus }
            Start-Process -FilePath $PowerShellConsoleConstants.Executables.ConEmuC -ArgumentList "-StoreCWD `"$path`"" -WindowStyle Hidden
        }

        if ($NestedPromptLevel -ne 0) {
            Write-Host -ForegroundColor $promptSecurityContext -NoNewLine " ($NestedPromptLevel)"
        }

        return "$ "
    }
    finally {
        # Make sure the exit code is preserved
        if ($Global:LASTEXITCODE -ne $originalLASTEXITCODE) {
            Set-Variable -Name LASTEXITCODE -Scope Global -Value $originalLASTEXITCODE -Force
        }
    }
}).GetNewClosure())