Set-StrictMode -Version Latest

$InstallPath = Get-Item -Path Env:\PowerShellConsoleInstallPath | % Value

$ModuleInitLevel = & (Join-Path $PSScriptRoot "Helpers\Module Init Level.ps1")

if ($ModuleInitLevel -le 1) {
	Import-Module (Join-Path $PSScriptRoot "Helpers\Profiler.psm1")
	Set-ProfilerStep Begin "FilterModuleInitializationSteps"
}
$moduleInitializationSteps = Get-Item -Path (Join-Path $PSScriptRoot "ModuleInitialization") -PipelineVariable ModuleInitializationDir | 
								Get-ChildItem -Recurse -Filter "*.ps1" |
								Sort-Object -Property FullName |
								% {
									$moduleStepDetails = & "$($_.FullName)" -GetModuleStepDetails
									@{
										Name =  $_.FullName.Substring($ModuleInitializationDir.FullName.Length + 1)
										Path = $_.FullName
										RunLevel = $moduleStepDetails.RunLevel
										Critical = $moduleStepDetails.Critical
									}
								}
if ($ModuleInitLevel -le 1) { Set-ProfilerStep End }

$moduleLoadSucceeded = $true
foreach ($step in $moduleInitializationSteps) {
	if ($step.RunLevel -ne -1 -and $step.RunLevel -le $ModuleInitLevel) { continue }
	if ($ModuleInitLevel -le 1) { Set-ProfilerStep Begin $step.Name }
	try {
		. "$($step.Path)"
	}
	catch {
		$moduleLoadSucceeded = $false
		Write-Host -ForegroundColor Red "ERROR: Module initialization step '$($step.Name)' failed."
		Write-Host -ForegroundColor Red "Message - $($_.Exception.Message)"
		Write-Host -ForegroundColor Red "Script - $($_.InvocationInfo.ScriptName)"
		Write-Host -ForegroundColor Red "Line - $($_.InvocationInfo.ScriptLineNumber)"
		Write-Host -ForegroundColor Red "Column - $($_.InvocationInfo.OffsetInLine)"
		if ($step.Critical) {
			Write-Host -ForegroundColor Red "Module Step is critical, aborting initialization."
			break
		}
	}
	finally {
		if ($ModuleInitLevel -le 1) { Set-ProfilerStep End }
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