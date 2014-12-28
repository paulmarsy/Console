param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = -1; Critical = $true}) }

$envrionmentVariableName = "ExtensibleEnvironmentConfigured"

[System.Environment]::SetEnvironmentVariable($envrionmentVariableName, "true", [System.EnvironmentVariableTarget]::Process)

(Get-ModulePrivateData -Name OnRemove).ScriptBlocks += ({
	[System.Environment]::SetEnvironmentVariable($envrionmentVariableName, $null, [System.EnvironmentVariableTarget]::Process)
}.GetNewClosure())