param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return 2 }

if (Test-Path -Path Function:Global:prompt) {
    Remove-Item -Path Function:Global:prompt -Force
}

New-Item -Path Function:Global:prompt -Force -Value ([ScriptBlock]::Create({
    [CmdletBinding()]
    param ()

    function _getSecurityContext {
        if (-not ($ProfileConfig.Temp.ContainsKey("SecurityContext"))) {
            $windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
            $windowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal $windowsIdentity
            if ($windowsPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) { $ProfileConfig.Temp.SecurityContext = "Red" }
            else { $ProfileConfig.Temp.SecurityContext = "Green" }
        }
        return $ProfileConfig.Temp.SecurityContext
    }

    function _writePrompt {
        param ($Object)
        
        Write-Host -ForegroundColor (_getSecurityContext) -NoNewLine -Object $Object
    }

    try {
        $realLASTEXITCODE = $LASTEXITCODE

        if ($PSCmdlet.GetVariableValue("PSDebugContext")) {
           _writePrompt "[DBG] "
        }

        if ((Split-Path -Resolve $PWD -Parent | Is NullOrWhiteSpace -Bool) -eq $true) { $path = Split-Path $PWD -Qualifier }
        else { $path = Split-Path $PWD -Parent | Get-ChildItem -Filter (Split-Path $PWD -Leaf) -Force | Select-Object -ExpandProperty Name }

        if ($path) {
            _writePrompt $path
            Write-VcsStatus
        } else {
            _writePrompt "<Invalid Path>"
        }

        if ($NestedPromptLevel -ne 0) {
            _writePrompt " ($NestedPromptLevel)"
        }

        return "$ "
    }
    finally {
        $global:LASTEXITCODE = $realLASTEXITCODE    
    }
}))