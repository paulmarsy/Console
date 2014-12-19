param([switch]$GetModuleStepDetails)
if ($GetModuleStepDetails) { return (@{RunLevel = -1; Critical = $true}) }

if ($null -eq $ExecutionContext.SessionState.Module.PrivateData) {
	$ExecutionContext.SessionState.Module.PrivateData = New-Object -TypeName System.Management.Automation.PSObject
}

function Add-ModulePrivateData {
	param(
		[Parameter(Mandatory=$true)]$Name,
		[Parameter(Mandatory=$true)]$Value
	)

	$ExecutionContext.SessionState.Module.PrivateData | Add-Member -MemberType NoteProperty -Name $Name -Value $Value -Force
}

function Get-ModulePrivateData {
	param(
		[Parameter(Mandatory=$true)]$Name
	)

	return ($ExecutionContext.SessionState.Module.PrivateData | Select-Object -Property $Name | Select-Object -ExpandProperty $Name)
}