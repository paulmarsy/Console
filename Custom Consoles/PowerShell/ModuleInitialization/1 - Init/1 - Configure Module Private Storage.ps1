param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = -1; Critical = $true}) }

if ($null -eq $ExecutionContext.SessionState.Module.PrivateData) {
	$ExecutionContext.SessionState.Module.PrivateData = @{}
}

function Add-ModulePrivateData {
	param(
		[Parameter(Mandatory=$true)]$Name,
		[Parameter(Mandatory=$true)]$Value
	)

	$ExecutionContext.SessionState.Module.PrivateData.Add($Name, $Value)
}

function Get-ModulePrivateData {
	param(
		[Parameter(Mandatory=$true)]$Name
	)

	return $ExecutionContext.SessionState.Module.PrivateData.Item($Name)
}