function Show-PowerShellModuleProfiler {
	 if (-not (Get-Module Profiler)) {
	 	throw "Profiler module is not loaded, was fast-init used?"
	 }

	Show-ProfilerResults
}