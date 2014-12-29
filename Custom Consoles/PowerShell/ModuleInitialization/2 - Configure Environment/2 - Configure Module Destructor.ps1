param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = -1; Critical = $true}) }

Add-ModulePrivateData -Name OnRemove -Value (@{ScriptBlocks = ({@()}.Invoke())})

$ExecutionContext.SessionState.Module.OnRemove = {
	Get-ModulePrivateData -Name OnRemove | % ScriptBlocks | % { 
		try { $_.Invoke() }
		catch { Write-Error $_.Message }
	}
}