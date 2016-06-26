param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $false}) }

if ($ProfileConfig.General.IsAdmin) { $promptSecurityContext = "Red" }
else { $promptSecurityContext = "Green" }

if (Test-Path -Path Function:Global:prompt) {
    Remove-Item -Path Function:Global:prompt -Force
}

$promptCache = @{ Path = $null; Prompt = $null; IsGitRepo = $false }

New-Item -Path Function:Global:prompt -Force -Value ([ScriptBlock]::Create({
    [CmdletBinding()]
    param ()
    
    if ($PSCmdlet.GetVariableValue("PSDebugContext")) {
        Write-Host -ForegroundColor $promptSecurityContext -NoNewLine "[DBG] "
    }
    
    if ($PWD.Provider.Name -eq 'FileSystem') {
        $path = $PWD.ProviderPath.TrimEnd('\')
    } else {
        $path = $PWD.Path.TrimEnd('\')       
    }
    if ($promptCache.Path -ne $path) {
        $directory = [System.IO.Path]::GetDirectoryName($path)
        if ([string]::IsNullOrWhiteSpace($directory)) {
            $promptCache.Prompt = $path
        } else { 
            $promptCache.Prompt = (Get-ChildItem -Path $directory -Name ([System.IO.Path]::GetFileName($path)) -Directory -Force).PSChildName
            if (Get-GitDirectory) {
                $promptCache.IsGitRepo = $true
            } else {
                $promptCache.IsGitRepo = $false
            }
        }
        $promptCache.Path = $path
    }

    Write-Host -ForegroundColor $promptSecurityContext -NoNewLine $promptCache.Prompt
    if ($promptCache.IsGitRepo -and (Test-Path Function:\Write-VcsStatus)) {
        Write-VcsStatus
    }

    if ($NestedPromptLevel -ne 0) {
        Write-Host -ForegroundColor $promptSecurityContext -NoNewLine " ($NestedPromptLevel)"
    }

    return "$ "
}).GetNewClosure())