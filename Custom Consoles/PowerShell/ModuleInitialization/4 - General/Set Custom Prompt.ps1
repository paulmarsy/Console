param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 3; Critical = $false}) }

$promptCache = @{ Path = $null; Prompt = $null }
if ($ProfileConfig.General.IsAdmin) { $promptCache.ForegroundColor = [System.ConsoleColor]::Red }
else { $promptCache.ForegroundColor = [System.ConsoleColor]::Green }

if (Test-Path -Path Function:Global:prompt) {
    Remove-Item -Path Function:Global:prompt -Force
}
New-Item -Path Function:Global:prompt -Force -Value ([ScriptBlock]::Create({
    [CmdletBinding()]
    param()

    $promptText = New-Object -TypeName System.Text.StringBuilder
    
    if ($PSCmdlet.GetVariableValue("PSDebugContext")) {
        [void]$promptText.Append("[DBG] ")
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
        }
        $promptCache.Path = $path
    }
    [void]$promptText.Append($promptCache.Prompt)

    if ($NestedPromptLevel -ne 0) {
        [void]$promptText.Append(" ($NestedPromptLevel)")
    }
    
    [System.Console]::ForegroundColor = $promptCache.ForegroundColor
    [System.Console]::Write($promptText)
    [System.Console]::ResetColor()

    return "$ "
}).GetNewClosure())