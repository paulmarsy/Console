Set-StrictMode -Version Latest

$InstallPath = Get-Item -Path Env:\PowerShellConsoleInstallPath | % Value

$ModuleFastInitLevel = & (Join-Path $PSScriptRoot "Helpers\Module Fast-Init Level.ps1")

if ($ModuleFastInitLevel -le 1) {
	Import-Module (Join-Path $PSScriptRoot "Helpers\Profiler.psm1")
	Set-ProfilerStep Begin "FilterModuleInitializationSteps"
}
$moduleInitializationSteps = Get-Item -Path (Join-Path $PSScriptRoot "ModuleInitialization") -PipelineVariable ModuleInitializationDir | 
								Get-ChildItem -Recurse -Filter "*.ps1" |
								Sort-Object -Property FullName |
								% {
									@{
										Name =  $_.FullName.Substring($ModuleInitializationDir.FullName.Length + 1)
										Path = $_.FullName
										StepRunLevel = (& "$($_.FullName)" -GetModuleInitStepRunLevel)
									}
								}
if ($ModuleFastInitLevel -le 1) { Set-ProfilerStep End }

$moduleLoadSucceeded = $true
foreach ($step in $moduleInitializationSteps) {
	if ($step.StepRunLevel -ne -1 -and $step.StepRunLevel -le $ModuleFastInitLevel) { continue }
	if ($ModuleFastInitLevel -le 1) { Set-ProfilerStep Begin $step.Name }
	try {
		. "$($step.Path)"
	}
	catch {
		$exception = $_.Exception
		Write-Host -ForegroundColor Red "ERROR: Module initialization step '$step.Name' failed with the error '$($exception.Message)' at line $($exception.Line), character $($exception.Offset)"
		$moduleLoadSucceeded = $false
		break
	}
	finally {
		if ($ModuleFastInitLevel -le 1) { Set-ProfilerStep End }
	}
}

& (Join-Path $PSScriptRoot "Helpers\Module Destructor.ps1")

if ($ProfileConfig.Temp.ContainsKey("ModuleExports")) {
	Export-ModuleMember -Function $ProfileConfig.Temp.ModuleExports.Functions -Alias $ProfileConfig.Temp.ModuleExports.Aliases
}

Write-Host
if ($moduleLoadSucceeded) {
	Write-Host -ForegroundColor Green "PowerShell Console Module successfully loaded"
} else {
	Write-Host -ForegroundColor Red "PowerShell Console Module encountered errors while loading"
}