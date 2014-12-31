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
        $realLASTEXITCODE = Get-Variable -Name LASTEXITCODE -Scope Global -ValueOnly

        if ($PSCmdlet.GetVariableValue("PSDebugContext")) {
           _writePrompt "[DBG] "
        }

        $currentPath = Get-Variable -Name PWD -Scope Global -ValueOnly
        if ([string]::IsNullOrWhiteSpace((Split-Path -Resolve $currentPath -Parent))) { $path = $currentPath.Drive.Name }
        else { $path = Split-Path $currentPath -Parent | Get-ChildItem -Force | ? PSChildName -eq (Split-Path $currentPath -Leaf) | Select-Object -ExpandProperty PSChildName }
        if ($path) {
            _writePrompt $path
            if ($currentPath.Provider.Name -eq "FileSystem" -and $null -ne (Get-Module posh-git)) { Write-VcsStatus }
        } else {
            _writePrompt "<Invalid Path>"
        }

        $npl = Get-Variable -Name NestedPromptLevel -ValueOnly
        if ($npl -ne 0) {
            _writePrompt " ($npl)"
        }

        return "$ "
    }
    finally {
        Set-Variable -Name LASTEXITCODE -Scope Global -Value $realLASTEXITCODE
    }
}).GetNewClosure())