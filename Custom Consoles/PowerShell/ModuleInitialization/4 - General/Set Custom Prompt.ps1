param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $false}) }

$windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$windowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal $windowsIdentity
if ($windowsPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) { $promptSecurityContext = "Red" }
else { $promptSecurityContext = "Green" }


if (Test-Path -Path Function:Global:prompt) {
    Remove-Item -Path Function:Global:prompt -Force
}

New-Item -Path Function:Global:prompt -Force -Value ([ScriptBlock]::Create({
    [CmdletBinding()]
    param ()

    function _writePrompt {
        param ($Object)
        
        Write-Host -ForegroundColor $promptSecurityContext -NoNewLine -Object $Object
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
            if (Get-Module posh-git) { Write-VcsStatus }
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
}).GetNewClosure())