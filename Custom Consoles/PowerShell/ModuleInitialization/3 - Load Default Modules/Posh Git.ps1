param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = 2; Critical = $false}) }

Export-Module posh-git
$GitPromptSettings.EnableWindowTitle = "Windows PowerShell - Git - "
Enable-GitColors
Start-SshAgent -Quiet

Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action {
	Stop-SshAgent
} | Out-Null

$ExecutionContext.SessionState.Module.OnRemove = {
	Stop-SshAgent
	if (Test-Path Variable:Global:VcsPromptStatuses) {
    	Remove-Variable -Name "VcsPromptStatuses" -Scope Global
    }
}