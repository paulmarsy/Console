$destructor = {

}

$psEngineExitEventJob = Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action $destructor

$ExecutionContext.SessionState.Module.OnRemove = {
    $psEngineExitEventJob | Stop-Job -PassThru | Remove-Job

    $destructor.Invoke()
}.GetNewClosure()