function Show-PowerShellModuleProfile {
	param(
		[switch]$OrderByDuration
	)
	 if (-not (Get-Module Profiler)) {
	 	throw "Profiler module is not loaded, was fast-init used?"
	 }

	Show-ProfilerResults -OrderByDuration:$OrderByDuration
}