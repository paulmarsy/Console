param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

Export-Module posh-git
$GitPromptSettings.EnableWindowTitle = "Windows PowerShell - Git - "
Enable-GitColors

$ExecutionContext.SessionState.Module.OnRemove = {
	if (Test-Path Variable:Global:VcsPromptStatuses) {
    	Remove-Variable -Name "VcsPromptStatuses" -Scope Global
    }
}