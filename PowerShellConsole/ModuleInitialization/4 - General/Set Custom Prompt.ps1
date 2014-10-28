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

Set-Item -Path Function:\prompt -Value {
    [CmdletBinding()]
    param ()

    $realLASTEXITCODE = $LASTEXITCODE

    if ($PSCmdlet.GetVariableValue("PSDebugContext")) {
       _writePrompt "[DBG] "
    }

    if ((Split-Path $pwd -NoQualifier) -eq "\") { $path = Split-Path $pwd -Qualifier }
    else { $path = Split-Path $pwd -Parent | Get-ChildItem -Filter (Split-Path $pwd -Leaf) -Force | Select-Object -ExpandProperty Name }

    if ($path) {
        _writePrompt $path
        Write-VcsStatus
    } else {
        _writePrompt "<Invalid Path>"
    }

    if ($NestedPromptLevel -ne 0) {
        _writePrompt " ($NestedPromptLevel)"
    }

    $global:LASTEXITCODE = $realLASTEXITCODE
    
    return "$ "
}