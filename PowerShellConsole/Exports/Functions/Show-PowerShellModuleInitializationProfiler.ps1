function Show-PowerShellModuleProfiler {
	 if (-not (Get-Module Profiler)) {
	 	Write-Host -ForegroundColor Red "ERROR: Profiler module is not loaded, was fast-init used?"
	 	return
	 }

	Show-ProfilerResults
}