# GitHub Windows - http://windows.github.com/
& (Join-Path $env:LOCALAPPDATA "GitHub\shell.ps1") -SkipSSHSetup
Import-Module posh-git -Global
$GitPromptSettings.EnableWindowTitle = "Windows PowerShell - Git - "
Enable-GitColors
Start-SshAgent -Quiet

$eventJob = Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action {
    Stop-SshAgent
}
$ExecutionContext.SessionState.Module.OnRemove = {
	Unregister-Event -SubscriptionId $eventJob.Id
}.GetNewClosure()