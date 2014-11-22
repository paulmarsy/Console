param([switch]$GetModuleInitStepRunLevel)
if ($GetModuleInitStepRunLevel) { return 2 }

Import-Module posh-git -Global
$GitPromptSettings.EnableWindowTitle = "Windows PowerShell - Git - "
Enable-GitColors
Start-SshAgent -Quiet

$eventJob = Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action {
    Stop-SshAgent
}
$ExecutionContext.SessionState.Module.OnRemove = {
	$eventJob | Stop-Job -PassThru | Remove-Job
}.GetNewClosure()